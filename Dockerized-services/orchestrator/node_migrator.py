import json
import time
import os

def load_json(filename):
    try:
        with open(filename, "r") as f:
            return json.load(f)
    except Exception:
        return []

def point_in_square(lat, lon, corners):
    lats = [c["lat"] for c in corners]
    lons = [c["lon"] for c in corners]
    return min(lats) <= lat <= max(lats) and min(lons) <= lon <= max(lons)

def get_pop_for_point(lat, lon, pops_boundaries):
    for pop in pops_boundaries:
        if point_in_square(lat, lon, pop["corners"]):
            return pop["region"]
    return None

def run_migrator():
    pops_boundaries = load_json("/app/pops_boundaries.json")
    instances_info = load_json("/app/instances-info.json")
    prediction_sequences = load_json("/app/prediction_sequences.json")
    car_sequences = load_json("/app/car_sequences.json")

    current_pop = os.getenv("POP_NAME", "unknown")

    # 1. Ver si lucas o joe están presentes en instances-info.json
    lucas_present = any(str(inst.get("uid")) == "1" for inst in instances_info)
    joe_present = any(str(inst.get("uid")) == "8" for inst in instances_info)

    # 2. Buscar predicciones para lucas y joe
    lucas_pred = next((pred for pred in prediction_sequences if str(pred.get("uid")) == "1"), None)
    joe_pred = next((pred for pred in prediction_sequences if str(pred.get("uid")) == "8"), None)

    # 3. Procesar predicción de lucas
    if lucas_present and lucas_pred:
        lat, lon = lucas_pred["prediction"][0], lucas_pred["prediction"][1]
        pop_pred = get_pop_for_point(lat, lon, pops_boundaries)
        if pop_pred == current_pop:
            print("[LOG] lucas: No action needed, future position is inside current pop.")
        else:
            print(f"[LOG] lucas: Migration needed from {current_pop} to {pop_pred} (prediction: {lat}, {lon})")

    # 4. Procesar predicción de joe
    if joe_present and joe_pred:
        lat, lon = joe_pred["prediction"][0], joe_pred["prediction"][1]
        pop_pred = get_pop_for_point(lat, lon, pops_boundaries)
        if pop_pred == current_pop:
            print("[LOG] joe: No action needed, future position is inside current pop.")
        else:
            print(f"[LOG] joe: Migration needed from {current_pop} to {pop_pred} (prediction: {lat}, {lon})")

    # 5. Procesar coches (opcional, ejemplo para un coche con uid=car11)
    for car in car_sequences:
        uid = car.get("uid")
        seq = car.get("sequence", [])
        if not seq or len(seq[0]) < 2:
            continue
        lat, lon = seq[0][0], seq[0][1]
        pop_pred = get_pop_for_point(lat, lon, pops_boundaries)
        # Busca si el coche está en instances_info
        car_present = any(str(inst.get("uid")) == str(uid) for inst in instances_info)
        if car_present:
            pop_actual = current_pop
        else:
            pop_actual = None
        if pop_actual and pop_pred and pop_actual != pop_pred:
            print(f"[LOG] Car {uid} will migrate from {pop_actual} to {pop_pred} (prediction: {lat}, {lon})")
        elif pop_actual and pop_pred and pop_actual == pop_pred:
            print(f"[LOG] Car {uid}: No action needed, future position is inside current pop.")

def main():
    while True:
        run_migrator()
        time.sleep(5)

if __name__ == "__main__":
    main()