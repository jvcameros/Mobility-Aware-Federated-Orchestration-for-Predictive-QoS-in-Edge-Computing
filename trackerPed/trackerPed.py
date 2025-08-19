from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel, Field
from datetime import datetime
import httpx
import os
import math

user = os.getenv("USER_NAME", "unknown")

app = FastAPI()

class GatewayRequest(BaseModel):
    latitude: float
    longitude: float
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

    # Codificación cíclica del día de la semana
    weekday_index = now.weekday()
    weekday_angle = 2 * math.pi * weekday_index / 7.0
    weekday_sin = math.sin(weekday_angle)
    weekday_cos = math.cos(weekday_angle)

    orchestrator_payload = {
        "latitude": data.latitude,
        "longitude": data.longitude,
        "user": user,
        "hour_sin": hour_sin,
        "hour_cos": hour_cos,
        "weekday_sin": weekday_sin,
        "weekday_cos": weekday_cos
    }

    errors = []
    orchestrator_response_data = None

    async with httpx.AsyncClient() as client:
        headers = {"x-user-gateway": user}
        try:
            resp2 = await client.post(
                "http://10.0.150.100:1000/user_ingest",
                json=orchestrator_payload,
                headers=headers
            )
            resp2.raise_for_status()
            orchestrator_response_data = resp2.json()
        except Exception as e:
            errors.append(f"Error al comunicarse con el orquestador: {e}")

    if errors:
        raise HTTPException(status_code=502, detail="; ".join(errors))

    # Construir respuesta final
    result = {
        "orquestador_response": orchestrator_response_data
    }
    if proxy_response_data is not None:
        result["proxy_response"] = proxy_response_data
    return result