from fastapi import FastAPI, Request
import requests
import uvicorn
import time

edge_delay = []
client_response = {"edge_response": "", "cloud_response": ""}

app = FastAPI()

edge_url = "http://edge-service.car.svc.cluster.local:5000/real_time"
cloud_url = "http://cloud-service.car.svc.cluster.local:6000/road_side"

@app.post("/proxy")
async def decision(request: Request):
    global client_response
    data = await request.json()
    print("[PROXY] Received data:", data)

    # Log all incoming headers
    print("[PROXY] Headers:")
    for key, value in request.headers.items():
        print(f"  {key}: {value}")

    # Copiar las cabeceras relevantes para enviar a edge-service
    # No enviar cabeceras de hop-by-hop como Host, Content-Length, etc.
    forward_headers = {}
    for key, value in request.headers.items():
        # Filtrar algunas cabeceras que no deben enviarse
        if key.lower() not in ["host", "content-length", "content-type", "accept-encoding", "connection"]:
            forward_headers[key] = value

    # Es importante añadir Content-Type para json
    forward_headers["Content-Type"] = "application/json"

    # Real-time communication with edge (reenviando headers)
    edge_server_data = {
        "front_distance": data.get("front_distance"),
        "rear_distance": data.get("rear_distance")
    }
    t1 = time.time()
    edge_response = requests.post(url=edge_url, json=edge_server_data, headers=forward_headers)
    t2 = time.time()
    print(f"[PROXY] Edge server delay: {(t2 - t1) * 1000:.2f} ms")

    if edge_response.status_code == 200:
        client_response["edge_response"] = edge_response.json()
    else:
        print(f"[PROXY] Error with edge server: {edge_response.status_code}")

    # On-the-fly communication with cloud if needed
    if data.get("details") == "interested":
        cloud_response = requests.get(url=cloud_url)
        if cloud_response.status_code == 200:
            client_response["cloud_response"] = cloud_response.json()
        else:
            print(f"[PROXY] Error with cloud server: {cloud_response.status_code}")
    else:
        client_response["cloud_response"] = ""

    return client_response

@app.post("/update")
async def edge_endpoint_update(data: dict):
    global edge_url
    edge_url = data.get("edge_endpoint", edge_url)
    print(f"[PROXY] New edge URL set: {edge_url}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
    print("[PROXY] Server running")
