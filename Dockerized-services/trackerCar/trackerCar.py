# trackerGW.py
from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel, Field
from datetime import datetime
import httpx
import os
import math

# Nombre de usuario desde variable de entorno (opcional)
user = os.getenv("USER_NAME", "unknown")

app = FastAPI()

# Modelo Pydantic con campos opcionales para proxy
class GatewayRequest(BaseModel):
    latitude: float | None = Field(None, description="Not required")
    longitude: float | None = Field(None, description="Not required")
    front_distance: float | None = Field(None, description="Distancia frontal para proxy")
    rear_distance: float | None = Field(None, description="Distancia trasera para proxy")
    details: str | None = Field(None, description="Detalles para proxy")

@app.post("/")
async def gateway(request: Request, data: GatewayRequest):
    now = datetime.now()

    # Codificación cíclica de la hora
    hour_decimal = now.hour + now.minute / 60.0
    hour_angle = 2 * math.pi * hour_decimal / 24.0
    hour_sin = math.sin(hour_angle)
    hour_cos = math.cos(hour_angle)

    # Preparar payload para orquestador solo si hay lat/lon
    orchestrator_payload = None
    if data.latitude is not None and data.longitude is not None:
        orchestrator_payload = {
            "latitude": data.latitude,
            "longitude": data.longitude,
            "user": user,
            "hour_sin": hour_sin,
            "hour_cos": hour_cos,
        }

    errors = []
    proxy_response_data = None
    orchestrator_response_data = None

    async with httpx.AsyncClient() as client:
        headers = {"x-user-gateway": user}

        # Llamada condicional al proxy solo si envían los campos necesarios
        if data.front_distance is not None and data.rear_distance is not None and data.details is not None:
            try:
                proxy_payload = {
                    "front_distance": data.front_distance,
                    "rear_distance": data.rear_distance,
                    "details": data.details
                }
                resp = await client.post(
                    "http://proxy-service.car.svc.cluster.local:8000/proxy",
                    json=proxy_payload,
                    headers=headers
                )
                resp.raise_for_status()
                proxy_response_data = resp.json()
            except Exception as e:
                errors.append(f"Error al comunicarse con el proxy: {e}")

        # Llamada al orquestador solo si hay payload
        if orchestrator_payload:
            try:
                resp2 = await client.post(
                    "http://orchestrator.orchestrator.svc.cluster.local:1000/car_ingest",
                    json=orchestrator_payload,
                    headers=headers
                )
                resp2.raise_for_status()
                orchestrator_response_data = resp2.json()
            except Exception as e:
                errors.append(f"Error al comunicarse con el orquestador: {e}")

    # Solo falla si no hubo ninguna respuesta exitosa
    if not proxy_response_data and not orchestrator_response_data:
        raise HTTPException(status_code=502, detail="; ".join(errors) if errors else "No se pudo contactar con ningún servicio")

    # Construir respuesta final
    result = {}
    if orchestrator_response_data is not None:
        result["orquestador_response"] = orchestrator_response_data
    if proxy_response_data is not None:
        result["proxy_response"] = proxy_response_data
    return result