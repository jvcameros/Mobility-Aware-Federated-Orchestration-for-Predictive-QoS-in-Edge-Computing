from fastapi import FastAPI
from pydantic import BaseModel
from app.predictor import PredictionBatcher

app = FastAPI()
batcher = PredictionBatcher()

class PredictionRequest(BaseModel):
    sequence: list
    uid: int

@app.post("/predict")
async def predict(reqs: list[PredictionRequest]):
    results = await batcher.add_requests(reqs)
    return {"predictions": results}

@app.get("/healthz")
def health_check():
    return {"status": "ok"}
