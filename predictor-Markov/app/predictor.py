import json
import numpy as np
from collections import Counter

class MarkovPredictor:
    def __init__(self):
        self.transition_probs = {}
        self.global_time_slot_counts = {}
        self.global_overall_counts = {}
        self.ORDER = 5
        self.GRID_SIZE = 100
        # GPS bounds for Tokyo area
        self.lat_min, self.lat_max = 35.6, 36.5
        self.lon_min, self.lon_max = 139.5, 140.7
        self.load_models()
    
    def load_models(self):
        try:
            with open("app/markov_transition_probs.json", "r") as f:
                self.transition_probs = json.load(f)
            
            with open("app/markov_global_time_slot_counts.json", "r") as f:
                self.global_time_slot_counts = json.load(f)
            
            with open("app/markov_global_overall_counts.json", "r") as f:
                self.global_overall_counts = json.load(f)
            
            with open("app/markov_model_params.json", "r") as f:
                params = json.load(f)
                self.ORDER = params["ORDER"]
                self.GRID_SIZE = params["GRID_SIZE"]
            
            print("✅ Markov model loaded successfully")
        except Exception as e:
            print(f"❌ Error loading Markov model: {e}")
            import traceback
            traceback.print_exc()
    
    def gps_to_state(self, lat, lon):
        """Convert GPS coordinates to discrete state"""
        # Clamp to valid GPS bounds first
        lat = max(self.lat_min, min(self.lat_max, lat))
        lon = max(self.lon_min, min(self.lon_max, lon))
        
        # Normalize to [0, 1]
        lat_norm = (lat - self.lat_min) / (self.lat_max - self.lat_min)
        lon_norm = (lon - self.lon_min) / (self.lon_max - self.lon_min)
        
        # Convert to grid indices
        lat_bin = int(lat_norm * self.GRID_SIZE)
        lon_bin = int(lon_norm * self.GRID_SIZE)
        
        # Clamp to grid bounds
        lat_bin = max(0, min(self.GRID_SIZE - 1, lat_bin))
        lon_bin = max(0, min(self.GRID_SIZE - 1, lon_bin))
        
        return f"({lat_bin}, {lon_bin})"
    
    def state_to_gps(self, state_str):
        """Convert discrete state back to GPS coordinates"""
        try:
            # Parse state string
            state_str = state_str.strip("()")
            lat_bin, lon_bin = map(int, state_str.split(", "))
            
            # Clamp to valid grid range
            lat_bin = max(0, min(self.GRID_SIZE - 1, lat_bin))
            lon_bin = max(0, min(self.GRID_SIZE - 1, lon_bin))
            
            # Convert to normalized coordinates (use center of grid cell)
            lat_norm = (lat_bin + 0.5) / self.GRID_SIZE
            lon_norm = (lon_bin + 0.5) / self.GRID_SIZE
            
            # Convert to GPS coordinates
            lat = self.lat_min + lat_norm * (self.lat_max - self.lat_min)
            lon = self.lon_min + lon_norm * (self.lon_max - self.lon_min)
            
            print(f"🔄 State {state_str} -> GPS [{lat:.6f}, {lon:.6f}]")
            return [lat, lon]
            
        except Exception as e:
            print(f"❌ Error converting state '{state_str}' to GPS: {e}")
            # Return Tokyo center as fallback
            return [36.0, 140.0]
    
    def get_time_slot_from_features(self, hour_sin, hour_cos):
        """Reconstruct hour from sin/cos and convert to time slot"""
        try:
            hour = np.arctan2(hour_sin, hour_cos) / (2 * np.pi) * 24
            if hour < 0:
                hour += 24
            return str(int(hour * 2))  # 30-min slots (0-47)
        except:
            return "0"  # Default fallback
    
    def predict(self, sequence, uid):
        """
        Predict next location using Markov model
        sequence: list of 6-feature vectors [hour_sin, hour_cos, weekday_sin, weekday_cos, lat_gps, lon_gps]
        Returns: GPS coordinates
        """
        try:
            print(f"🔮 Markov prediction for uid: {uid}")
            print(f"📊 Sequence length: {len(sequence)}")
            
            if len(sequence) < self.ORDER:
                print(f"❌ Need at least {self.ORDER} points, got {len(sequence)}")
                return self._fallback_prediction(sequence[-1] if sequence else None)
            
            # Extract GPS coordinates and time info
            coords_gps = [[row[4], row[5]] for row in sequence]  # lat, lon
            last_features = sequence[-1]
            
            print(f"🗺️  Input GPS coordinates: {coords_gps}")
            
            # Convert GPS to states
            states = []
            for lat, lon in coords_gps[-self.ORDER:]:
                state = self.gps_to_state(lat, lon)
                states.append(state)
            
            past_states = tuple(states)
            past_states_key = str(past_states)
            
            print(f"🎯 Past states: {past_states}")
            
            # Get time slot from last observation
            time_slot = self.get_time_slot_from_features(last_features[0], last_features[1])
            print(f"⏰ Time slot: {time_slot}")
            
            # Try to find transition probability
            if past_states_key in self.transition_probs:
                if time_slot in self.transition_probs[past_states_key]:
                    probs = self.transition_probs[past_states_key][time_slot]
                    next_state = self._sample_from_probs(probs)
                    result = [self.state_to_gps(next_state)]
                    print(f"✅ Markov prediction result: {result}")
                    return result
                else:
                    print(f"⚠️ Time slot {time_slot} not found for this state sequence")
            else:
                print(f"⚠️ State sequence not found in transition probabilities")
            
            print(f"🔄 Using fallback prediction")
            return self._fallback_prediction(last_features)
            
        except Exception as e:
            print(f"❌ Markov prediction error: {e}")
            import traceback
            traceback.print_exc()
            return self._fallback_prediction(sequence[-1] if sequence else None)
    
    def _sample_from_probs(self, probs):
        """Sample next state from probability distribution"""
        if not probs:
            return "(50, 50)"  # Default center state
            
        states = list(probs.keys())
        probabilities = list(probs.values())
        
        # Normalize probabilities
        total = sum(probabilities)
        if total > 0:
            probabilities = [p / total for p in probabilities]
        else:
            probabilities = [1.0 / len(states)] * len(states)
        
        return np.random.choice(states, p=probabilities)
    
    def _fallback_prediction(self, last_features):
        """Fallback when no transition is found"""
        print("🔄 Using fallback prediction method")
        
        if last_features is None:
            print("🔄 No features available, returning Tokyo center")
            return [[36.0, 140.0]]  # Tokyo center
        
        try:
            # Try time-based fallback first
            time_slot = self.get_time_slot_from_features(last_features[0], last_features[1])
            print(f"🔄 Trying time-based fallback for slot: {time_slot}")
            
            if time_slot in self.global_time_slot_counts:
                probs = self.global_time_slot_counts[time_slot]
                # Convert string counts to proper probabilities
                total_counts = sum(int(count) for count in probs.values())
                if total_counts > 0:
                    prob_dict = {state: int(count)/total_counts for state, count in probs.items()}
                    state = self._sample_from_probs(prob_dict)
                    result = [self.state_to_gps(state)]
                    print(f"🔄 Time-based fallback result: {result}")
                    return result
        except Exception as e:
            print(f"⚠️ Time-based fallback failed: {e}")
        
        # Ultimate fallback - return last known location with small noise
        try:
            last_lat, last_lon = float(last_features[4]), float(last_features[5])
            print(f"🔄 Last known location: [{last_lat}, {last_lon}]")
            
            # Add small random noise (~100m)
            noise_lat = np.random.normal(0, 0.001)
            noise_lon = np.random.normal(0, 0.001)
            
            result_lat = last_lat + noise_lat
            result_lon = last_lon + noise_lon
            
            # Clamp to Tokyo bounds
            result_lat = max(self.lat_min, min(self.lat_max, result_lat))
            result_lon = max(self.lon_min, min(self.lon_max, result_lon))
            
            result = [[result_lat, result_lon]]
            print(f"🔄 Location-based fallback result: {result}")
            return result
            
        except Exception as e:
            print(f"⚠️ Location-based fallback failed: {e}")
            print("🔄 Ultimate fallback: Tokyo center")
            return [[36.0, 140.0]]  # Tokyo center
