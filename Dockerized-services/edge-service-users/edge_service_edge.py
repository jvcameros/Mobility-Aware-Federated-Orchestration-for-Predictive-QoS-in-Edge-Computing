# edge_service_edge.py
from fastapi import FastAPI, HTTPException, Request
import uvicorn
import time
import os  # ← añadido para acceder a variables de entorno

app = FastAPI()

user_name = os.getenv("USER", "unknown-cluster")  # ← obtenemos la variable de entorno
i = 0

@app.post("/real_time")
async def store_data(request: Request):
    global i
    try:
        data = await request.json()
        user_gateway = request.headers.get("x-user-gateway", "not provided")

        instruction = {
            "acceleration": "",
            "steering": "",
            "source": user_name
        }

        for item in data:
            if item == "front_distance":
                value = int(data[item])
                if value < 20:
                    instruction["acceleration"] = "break"
                elif value > 40:
                    instruction["acceleration"] = "slow down"
                else:
                    instruction["acceleration"] = "keep going"
            elif item == "rear_distance":
                value = int(data[item])
                if value < 15:
                    instruction["steering"] = "dont steer"
                elif 15 <= value < 50:
                    instruction["steering"] = "be careful while steering"
                else:
                    instruction["steering"] = "steer free"

        print(f"[EDGE LOG] Petición recibida de gateway: {user_gateway}")
        print(f"[EDGE LOG] Instrucciones generadas: {instruction}")

        i += 1
        if i % 10 == 0:
            time.sleep(5)

        return instruction

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
