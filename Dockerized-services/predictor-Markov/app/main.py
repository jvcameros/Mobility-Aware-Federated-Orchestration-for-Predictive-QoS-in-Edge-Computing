from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
from .model_loader import load_model

app = FastAPI(title="Markov Location Prediction API")

predictor = load_model()

class PredictionItem(BaseModel):
    sequence: List[List[float]]
    uid: int

@app.post("/predict")
async def predict_location(requests: List[PredictionItem]):
    try:
        results = []
        
        for req in requests:
            prediction = predictor.predict(req.sequence, req.uid)
            if prediction is None:
                prediction = [[0.0, 0.0]]  # Fallback
            
            results.append({
                "prediction": prediction,
                "uid": req.uid
            })
        
        return results
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health_check():
    return {"status": "healthy", "model": "Markov"}
