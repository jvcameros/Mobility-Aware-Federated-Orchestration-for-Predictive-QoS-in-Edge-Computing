import json
import os
import time
import subprocess

def load_json(filename):
    try:
        with open(filename, "r") as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading {filename}: {e}")
        return []

def get_registered_nodes(instances_info):
    """
    List of registered nodes in the pop excluding master nodes 
    """
    nodes = []
    for inst in instances_info:
        name = str(inst.get("name", ""))
        if not name.startswith("master"):
            nodes.append(name)
    return nodes

def get_pop_for_point(lat, lon, pop_boundaries):
    """
    Returns the name of the pop to which the position (lat, lon) belongs.
    """
    for pop in pop_boundaries:
        corners = pop["corners"]
        lats = [c["lat"] for c in corners]
        lons = [c["lon"] for c in corners]
        if min(lats) <= lat <= max(lats) and min(lons) <= lon <= max(lons):
            return pop["region"]
    return "unknown"

def get_future_positions(nodes, car_sequences, prediction_sequences):
    """
    Returns a dictionary with the future positions of the nodes present in the list nodes.
    For cars, it takes the coordinates from car_sequences.
    For walkers, it takes the predictions from prediction_sequences (mapping 0->joe, 1->lucas).
    """
    future_positions = {}

    # Procesar coches
    for car in car_sequences:
        uid = str(car.get("uid"))
        if uid in nodes:
            seq = car.get("sequence", [])
            if seq and len(seq[0]) >= 2:
                lat, lon = seq[0][0], seq[0][1]
                future_positions[uid] = (lat, lon)

    # Procesar caminantes (joe y lucas)
    for pred in prediction_sequences:
        pred_uid = str(pred.get("uid"))
        if pred_uid == "0" and "joe" in nodes:
            pred_pos = pred.get("prediction", [])
            if len(pred_pos) >= 2:
                lat, lon = pred_pos[0], pred_pos[1]
                future_positions["joe"] = (lat, lon)
        elif pred_uid == "1" and "lucas" in nodes:
            pred_pos = pred.get("prediction", [])
            if len(pred_pos) >= 2:
                lat, lon = pred_pos[0], pred_pos[1]
                future_positions["lucas"] = (lat, lon)
    return future_positions

def main():
    current_pop = os.getenv("POP_NAME", "unknown")
    while True:
        # Read nodes registered in the pop
        instances_info = load_json("/app/instances-info.json")
        nodes = get_registered_nodes(instances_info)

        # Read future positions of cars and pedestrians predictions
        car_sequences = load_json("/app/car_sequences.json")
        prediction_sequences = load_json("/app/prediction_sequences.json")
        pop_boundaries = load_json("/app/pops_boundaries.json")
        future_positions = get_future_positions(nodes, car_sequences, prediction_sequences)



        # Shows found future positions
        for uid in future_positions:
            lat, lon = future_positions[uid]
            future_pop = get_pop_for_point(lat, lon, pop_boundaries)
            future_positions[uid] = {
                "lat": lat,
                "lon": lon,
                "pop": future_pop
            }        

        # Logic behind logs: if future position is different from current pop says it 
        #THE MIGRATION SCRIPT SHOULD BE ADDED HERE 
        for uid, info in future_positions.items():
            print(f"[INFO] Future position for {uid}: lat={info['lat']}, lon={info['lon']}, pop={info['pop']}")
            if info["pop"] != current_pop:
                migrate_script_path = "/app/migratePed.sh"
                # Asignación de destination_pop según el pop futuro
                if info["pop"] == "pop1":
                    destination_pop = "edge-cluster"
                elif info["pop"] == "pop2":
                    destination_pop = "cloud-cluster"
                else:
                    destination_pop = info["pop"]  # fallback por si acaso
                print(f"[LOG] Node {uid} must migrate from {current_pop} to {destination_pop} (future position: {info['lat']}, {info['lon']})")
                subprocess.Popen(["/bin/bash", migrate_script_path, uid, destination_pop])
                time.sleep(75)
        time.sleep(5)

if __name__ == "__main__":
    main()