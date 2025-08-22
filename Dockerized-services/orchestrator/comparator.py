import json
import time
import math
import os
import subprocess

CAR_SEQ_FILE = "car_sequences.json"
PRED_SEQ_FILE = "prediction_sequences.json"
EDGE_SERVERS_FILE = "edge_servers.json"


def load_json(filename):
    try:
        with open(filename, "r") as f:
            return json.load(f)
    except Exception:
        return []

def euclidean_distance(lat1, lon1, lat2, lon2):
    return math.sqrt((lat1 - lat2) ** 2 + (lon1 - lon2) ** 2)

EDGE_SERVERS_FILE = "/app/edge_servers.json"

def get_edge_servers():
    try:
        with open(EDGE_SERVERS_FILE, "r") as f:
            return json.load(f)
    except Exception:
        return []

def main():
    edge_servers = get_edge_servers()
    print(f"[LOG] Edge servers cargados: {edge_servers}")  # <-- Log de edge servers
    last_closest_uid = None  # Guardar el último nodo más cercano

    while True:
        car_seq = load_json(CAR_SEQ_FILE)
        if not car_seq:
            time.sleep(5)
            continue

        car = car_seq[0]
        car_uid = car["uid"]
        car_lat, car_lon = car["sequence"][-1][0], car["sequence"][-1][1]

        pred_seq = load_json(PRED_SEQ_FILE)
        if not pred_seq:
            print("prediction_sequences.json empty, waiting 5 secs...")
            time.sleep(5)
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
                if int(uid) == 0:
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
            current_uid = str(closest["uid"])
            if current_uid != last_closest_uid:
                print(f"Closest node to {car_uid} is {current_uid} (distance: {min_dist:.6f})")
                deletion_script_path = "/app/del-svc-node.sh"
                deployment_script_path = "/app/boot-svc-node.sh"
                redirect_script_path = "/app/edit-access-svc-node.sh"
                uid_arg = current_uid
                # Solo borrar si last_closest_uid no es None
                if last_closest_uid is not None:
                    proc1 = subprocess.Popen(["/bin/bash", deletion_script_path, last_closest_uid])
                proc2 = subprocess.Popen(["/bin/bash", deployment_script_path, uid_arg])
                print(f"Deploying svc in {current_uid}...")
                time.sleep(5)
                proc3 = subprocess.Popen(["/bin/bash", redirect_script_path, uid_arg])
                last_closest_uid = current_uid
            else:
                print(f"Closest node to {car_uid} is still {current_uid} (distance: {min_dist:.6f}), no action taken.")
        else:
            print("Couldn't find any prediction or edge server.")

        time.sleep(5)

if __name__ == "__main__":
    main()