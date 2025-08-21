from fastapi import FastAPI 
from fastapi import Body
from pydantic import BaseModel
from typing import List
from fastapi import Body
import json
import os




app = FastAPI()
cluster = os.getenv("CLUSTER_NAME", "unknown")
pop = os.getenv("POP_NAME", "unknown")
prediction_file = "prediction_sequences.json"
car_file="car_sequences.json"

@app.on_event("startup")
async def startup_event():
    # Crea archivos si no existen
    for file_path in [prediction_file, car_file]:
        if not os.path.exists(file_path):
            with open(file_path, "w") as f:
                json.dump([], f, indent=2)

# Modelo Pydantic para los datos de ingest
class IngestData(BaseModel):
    latitude: float
    longitude: float
    user: str
    hour_sin: float
    hour_cos: float


# Estructura de cada punto en la secuencia
def create_data_point(data: IngestData) -> List[float]:
    return [
        data.latitude,
        data.longitude,
        data.hour_sin,
        data.hour_cos
    ]

def save_ingest(data: IngestData, target_file: str, replace_existing: bool = False):
    payload = data.dict()
    print(f"Received position from car {data.user}")

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

# API for car data ingestion
@app.post("/car_ingest")
async def car_ingest(data: IngestData):
    save_ingest(data, car_file, replace_existing=True )
    return {
        "status": "received",
        "cluster": pop
    }


class PredictionIngest(BaseModel): 
    uid: int
    prediction: List[float]


@app.post("/prediction_ingest")
async def prediction_ingest(predictions: List[PredictionIngest] = Body(...)):
    print("Received predictions from Centralized Predictor")
    # Guardar todas las predicciones en el archivo
    try:
        with open(prediction_file, "r") as f:
            all_data = json.load(f)
    except (json.JSONDecodeError, FileNotFoundError):
        all_data = []

    # Puedes guardar como reemplazo completo, o agregar (aquí reemplazo completo)
    all_data = [p.dict() for p in predictions]

    with open(prediction_file, "w") as f:
        json.dump(all_data, f, indent=2)