from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import json
import os
import httpx
from typing import List
import asyncio

app = FastAPI()
users_file = "user_sequences.json"
predictions_file = "predictions.json"

# Global variable for the predictor
markov_predictor = None

@app.on_event("startup")
async def startup_event():
    global markov_predictor
    
    # Load Markov model at startup with error handling
    try:
        from app.model_loader import load_model
        markov_predictor = load_model()
        print("✅ Markov predictor loaded successfully in orchestrator")
    except Exception as e:
        print(f"❌ Failed to load Markov predictor: {e}")
        import traceback
        traceback.print_exc()
    
    # Create files if they don't exist
    for file_path in [users_file, predictions_file]:
        if not os.path.exists(file_path):
            with open(file_path, "w") as f:
                json.dump([], f, indent=2)

    # Start prediction task in background
    asyncio.create_task(predict_periodically())

# Pydantic model for ingest
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
        data.hour_sin,
        data.hour_cos,
        data.weekday_sin,
        data.weekday_cos,
        data.latitude,
        data.longitude
    ]

def save_ingest(data: IngestData, target_file: str, replace_existing: bool = False):
    payload = data.dict()
    print(f"Received data in the orchestrator for {data.user}:")
    print(json.dumps(payload, indent=2, ensure_ascii=False))

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

# API for saving pedestrians position logs 
@app.post("/user_ingest")
async def user_ingest(data: IngestData):
    try:
        save_ingest(data, users_file)
        return {
            "status": "received for predicting"
        }
    except Exception as e:
        print(f"Error in user_ingest: {e}")
        raise HTTPException(status_code=500, detail=str(e))

# Direct prediction endpoint
@app.post("/predict")
async def predict_location(requests: List[dict]):
    global markov_predictor
    
    try:
        if markov_predictor is None:
            raise HTTPException(status_code=500, detail="Markov model not loaded")
            
        results = []
        for req in requests:
            print(f"🔮 Processing Markov prediction request for uid: {req.get('uid')}")
            print(f"📊 Sequence length: {len(req.get('sequence', []))}")
            
            prediction = markov_predictor.predict(req["sequence"], req["uid"])
            if prediction is None:
                print(f"❌ Markov prediction failed for uid: {req.get('uid')}")
                raise HTTPException(status_code=400, detail="Prediction failed")
            
            results.append({
                "prediction": prediction,
                "uid": req["uid"]
            })
        
        return results
    except Exception as e:
        print(f"❌ Error in predict_location: {e}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health_check():
    return {"status": "healthy", "model": "Markov"}

async def predict_periodically():
    global markov_predictor
    
    while True:
        try:
            if markov_predictor is None:
                print("⚠️ Markov predictor not loaded, skipping periodic predictions")
                await asyncio.sleep(30)
                continue
                
            # Load Sequences from users_file
            with open(users_file, "r") as f:
                all_data = json.load(f)
        except (json.JSONDecodeError, FileNotFoundError):
            all_data = []

        # Filter users with 5 or more entries
        to_predict = []
        for user_entry in all_data:
            seq = user_entry.get("sequence", [])
            if len(seq) >= 5:
                try:
                    # Use Markov predictor directly
                    prediction = markov_predictor.predict(seq[-5:], int(user_entry["uid"]))
                    if prediction:
                        to_predict.append({
                            "uid": int(user_entry["uid"]), 
                            "prediction": prediction
                        })
                except Exception as e:
                    print(f"Skipping invalid entry for uid {user_entry.get('uid')}: {e}")

        if to_predict:
            # Save predictions
            with open(predictions_file, "w") as f:
                json.dump(to_predict, f, indent=2)

            # Send to two different APIs
            try:
                async with httpx.AsyncClient() as client:
                    # First API
                    response1 = await client.post(
                        "http://10.0.100.126:31000/prediction_ingest",
                        json=to_predict,
                        timeout=10
                    )
                    response1.raise_for_status()
                    print(f"Predictions sent to PoP1: {response1.status_code}")

                    # Second API
                    response2 = await client.post(
                        "http://10.0.10.145:31001/prediction_ingest",
                        json=to_predict,
                        timeout=10
                    )
                    response2.raise_for_status()
                    print(f"Prediction sent to PoP2: {response2.status_code}")

            except Exception as e:
                print(f"Error sending predictions to external APIs: {e}")

        else:
            # Empty file if no predictions
            with open(predictions_file, "w") as f:
                json.dump([], f, indent=2)

        await asyncio.sleep(30)  # Wait 30 seconds before next cycle
