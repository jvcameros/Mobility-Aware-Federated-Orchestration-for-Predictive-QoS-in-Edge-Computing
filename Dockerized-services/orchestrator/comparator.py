import json
import time
import math
import os
import subprocess

CAR_SEQ_FILE = "car_sequences.json"
PRED_SEQ_FILE = "prediction_sequences.json"

def load_json(filename):
    try:
        with open(filename, "r") as f:
            return json.load(f)
    except Exception:
        return []

def euclidean_distance(lat1, lon1, lat2, lon2):
    return math.sqrt((lat1 - lat2) ** 2 + (lon1 - lon2) ** 2)

def get_edge_servers():
    edge_servers = []
    for i in [1, 2]:
        uid = os.getenv(f"EDGE_SERVER{i}_UID")
        lat = os.getenv(f"EDGE_SERVER{i}_LAT")
        lon = os.getenv(f"EDGE_SERVER{i}_LON")
        if uid and lat and lon:
            try:
                edge_servers.append({
                    "uid": uid,
                    "lat": float(lat),
                    "lon": float(lon)
                })
            except ValueError:
                continue
    return edge_servers

def main():
    edge_servers = get_edge_servers()
    while True:
        car_seq = load_json(CAR_SEQ_FILE)
        if not car_seq:
            print("car_sequences.json empty, waiting 15 segs...")
            time.sleep(15)
            continue

        car = car_seq[0]
        car_uid = car["uid"]
        car_lat, car_lon = car["sequence"][-1][0], car["sequence"][-1][1]

        pred_seq = load_json(PRED_SEQ_FILE)
        if not pred_seq:
            print("prediction_sequences.json empty, waiting 15 secs...")
            time.sleep(15)
            continue

        candidates = []
        # Añadir predicciones dinámicas
        for pred in pred_seq:
            candidates.append({
                "uid": pred["uid"],
                "lat": pred["prediction"][0],
                "lon": pred["prediction"][1]
            })
        # Añadir edge servers estáticos
        candidates.extend(edge_servers)

        min_dist = float("inf")
        closest = None

        for cand in candidates:
            uid = cand.get("uid")
            try:
                if int(uid) == 8:
                    cand["uid"] = "joe"
                elif int(uid) == 1:
                    cand["uid"] = "lucas"
            except Exception:
        # si no es convertible a int, lo dejamos tal cual
                pass
            dist = euclidean_distance(car_lat, car_lon, cand["lat"], cand["lon"])
            if dist < min_dist:
                min_dist = dist
                closest = cand

        if closest:
            print(f"Closest node to {car_uid} is {closest['uid']} (distance: {min_dist:.6f})")

            script_path = "/app/edit-access-svc-node.sh"
            uid_arg = str(closest["uid"])
            proc = subprocess.Popen(["/bin/bash", script_path, uid_arg])
        else:
            print("Couldn't find any prediction or edge server.")

        time.sleep(15)

if __name__ == "__main__":
    main()