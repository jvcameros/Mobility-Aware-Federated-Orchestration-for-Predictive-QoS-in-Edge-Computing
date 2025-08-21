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
    hour_sin: float
    hour_cos: float
    weekday_sin: float
    weekday_cos: float

@app.post("/")
async def gateway(request: Request, data: GatewayRequest):
    now = datetime.now()

    
    orchestrator_payload = {
        "latitude": data.latitude,
        "longitude": data.longitude,
        "user": user,
        "hour_sin": data.hour_sin,
        "hour_cos": data.hour_cos,
        "weekday_sin": data.weekday_sin,
        "weekday_cos": data.weekday_cos
    }

    errors = []
    orchestrator_response_data = None
    proxy_response_data = None   # 🔹 inicializamos antes de usarlo

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

    # 🔹 Construir respuesta final
    result = {
        "predictor_response": orchestrator_response_data
    }
    if proxy_response_data is not None:
        result["proxy_response"] = proxy_response_data

    return result
