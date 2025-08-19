cat predictor.py 
from fastapi import FastAPI
from pydantic import BaseModel
import json
import os
import httpx
from typing import List
import asyncio
from app.predictor import PredictionBatcher, PredictionRequest

app = FastAPI()
users_file = "user_sequences.json"
predictions_file = "predictions.json"

batcher = PredictionBatcher(batch_window_sec=1.0)  # Mismo batch_window que el predictor

@app.on_event("startup")
async def startup_event():
    # Crea archivos si no existen
    for file_path in [users_file, predictions_file]:
        if not os.path.exists(file_path):
            with open(file_path, "w") as f:
                json.dump([], f, indent=2)

    # Arranca la tarea de predicción en background
    asyncio.create_task(predict_periodically())

# Modelo Pydantic para ingest
class IngestData(BaseModel):
    latitude: float
    longitude: float
    user: str
    hour_sin: float
    hour_cos: float
    weekday_sin: float
    weekday_cos: float

def create_data_point(data: IngestData) -> List[float]:
    return [
        data.latitude,
        data.longitude,
        data.weekday_sin,
        data.weekday_cos,
        data.hour_sin,
        data.hour_cos
    ]

def save_ingest(data: IngestData, target_file: str, replace_existing: bool = False):
    payload = data.dict()
    print(f"Received position from {data.user}:, ready for prediction")

    try:
        with open(target_file, "r") as f:
            all_data = json.load(f)
    except (json.JSONDecodeError, FileNotFoundError):
        all_data = []

    user_found = False
    for user_entry in all_data:
        if user_entry["uid"] == data.user:
            if replace_existing:
                user_entry["sequence"] = [create_data_point(data)]
            else:
                user_entry["sequence"].append(create_data_point(data))
            user_found = True
            break

    if not user_found:
        all_data.append({
            "uid": data.user,
            "sequence": [create_data_point(data)]
        })

    with open(target_file, "w") as f:
        json.dump(all_data, f, indent=2)

# API for saving pedetrians position logs 
@app.post("/user_ingest")
async def user_ingest(data: IngestData):
    try:
        save_ingest(data, users_file)
        return {
            "status": "received for predicting"
        }
    except Exception as e:
        print(f"Error en user_ingest: {e}")
        raise HTTPException(status_code=500, detail=str(e))

async def predict_periodically():
    while True:
        try:
            # Load Sequences from users_file
            with open(users_file, "r") as f:
                all_data = json.load(f)
        except (json.JSONDecodeError, FileNotFoundError):
            all_data = []

        # Filters users with 5 or more entries
        to_predict = []
        for user_entry in all_data:
            seq = user_entry.get("sequence", [])
            if len(seq) >= 5:
                try:
                    request = PredictionRequest(
                        uid=int(user_entry["uid"]),
                        sequence=seq[-5:]  # ✅ Solo las últimas 5 entradas
                    )
                    to_predict.append(request)
                except Exception as e:
                    print(f"Skipping invalid entry for uid {user_entry.get('uid')}: {e}")

        if to_predict:
            # Llamar al batcher para predecir
            preds = await batcher.add_requests(to_predict)

            # Guardar las predicciones
            predictions = [
                {"uid": r.uid, "prediction": p} for r, p in zip(to_predict, preds)
            ]
            with open(predictions_file, "w") as f:
                json.dump(predictions, f, indent=2)

            # Enviar a dos APIs distintas
            try:
                async with httpx.AsyncClient() as client:
                    # Primera API
                    response1 = await client.post(
                        "http://10.0.100.126:31000/prediction_ingest",  # Cambia esta URL
                        json=predictions,
                        timeout=10
                    )
                    response1.raise_for_status()
                    print(f"Predictions sent to PoP1: {response1.status_code}")

                    # Segunda API
                    response2 = await client.post(
                        "http://10.0.10.145:31001/prediction_ingest",  # Cambia esta URL
                        json=predictions,
                        timeout=10
                    )
                    response2.raise_for_status()
                    print(f"Prediction sent to PoP2: {response2.status_code}")

            except Exception as e:
                print(f"Error enviando predicciones a las APIs externas: {e}")

        else:
            # Vaciar archivo si no hay predicciones
            with open(predictions_file, "w") as f:
                json.dump([], f, indent=2)

        await asyncio.sleep(30)  # Espera 30 segundos antes de siguiente ciclo