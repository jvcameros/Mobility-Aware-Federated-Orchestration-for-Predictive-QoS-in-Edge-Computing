import pickle
import pandas as pd
import numpy as np
from sklearn.preprocessing import MinMaxScaler

class VARPredictor:
    def __init__(self):
        self.global_model = None
        self.history_steps = 0
        self.lat_scaler = None
        self.lon_scaler = None
        self.load_model()
        self.setup_scalers()
    
    def setup_scalers(self):
        """Setup scalers based on the training data ranges"""
        # From your training output: 
        # Latitude: 35.6 to 36.5, Longitude: 139.5 to 140.7
        self.lat_scaler = MinMaxScaler(feature_range=(35.6, 36.5))
        self.lon_scaler = MinMaxScaler(feature_range=(139.5, 140.7))
        
        # Fit scalers with dummy data to establish the transformation
        # Input range: 0 to 1 (normalized) -> Output range: actual GPS coordinates
        dummy_input = np.array([[0], [1]])
        self.lat_scaler.fit(dummy_input)
        self.lon_scaler.fit(dummy_input)
        
        print("✅ Coordinate scalers setup complete")
    
    def load_model(self):
        try:
            with open("app/var_global.pkl", "rb") as f:
                global_data = pickle.load(f)
                self.global_model = global_data["model"]
                self.history_steps = global_data["history_steps"]
            
            print(f"✅ Global VAR model loaded successfully (history_steps: {self.history_steps})")
        except Exception as e:
            print(f"❌ Error loading VAR model: {e}")
    
    def normalize_to_gps(self, normalized_coords):
        """Convert normalized coordinates [0-1] to actual GPS coordinates"""
        normalized_coords = np.array(normalized_coords)
        lat_normalized = normalized_coords[:, 0].reshape(-1, 1)
        lon_normalized = normalized_coords[:, 1].reshape(-1, 1)
        
        lat_gps = self.lat_scaler.transform(lat_normalized).flatten()
        lon_gps = self.lon_scaler.transform(lon_normalized).flatten()
        
        return np.column_stack([lat_gps, lon_gps])
    
    def gps_to_normalized(self, gps_coords):
        """Convert GPS coordinates back to normalized [0-1] range"""
        gps_coords = np.array(gps_coords)
        lat_gps = gps_coords[:, 0].reshape(-1, 1)
        lon_gps = gps_coords[:, 1].reshape(-1, 1)
        
        lat_normalized = self.lat_scaler.inverse_transform(lat_gps).flatten()
        lon_normalized = self.lon_scaler.inverse_transform(lon_gps).flatten()
        
        return np.column_stack([lat_normalized, lon_normalized])
    
    def predict(self, sequence, uid):
        """
        Predict next location using global VAR model
        sequence: list of 6-feature vectors [hour_sin, hour_cos, weekday_sin, weekday_cos, lat_norm, lon_norm]
        """
        try:
            if self.global_model is None:
                print("❌ Global model is None")
                return None
            
            # Extract normalized coordinates (assuming lat=index 4, lon=index 5)
            coords_normalized = [[row[4], row[5]] for row in sequence]
            print(f"📍 Normalized coordinates: {coords_normalized}")
            
            # Convert to GPS coordinates for VAR model
            coords_gps = self.normalize_to_gps(coords_normalized)
            print(f"🗺️  GPS coordinates: {coords_gps}")
            
            # Take the last N coordinates where N = history_steps
            history_array = coords_gps[-self.history_steps:]
            print(f"📈 History array shape: {history_array.shape}, needed history_steps: {self.history_steps}")
            
            if len(history_array) < self.history_steps:
                print(f"❌ Need at least {self.history_steps} historical points, got {len(history_array)}")
                return None
            
            print(f"🔮 Making prediction with GPS history: {history_array}")
            prediction_gps = self.global_model.forecast(history_array, steps=1)
            print(f"🗺️  GPS prediction: {prediction_gps}")
            
            # Convert prediction back to normalized coordinates
            prediction_normalized = self.gps_to_normalized(prediction_gps)
            result = prediction_normalized.tolist()
            print(f"✅ Normalized prediction result: {result}")
            
            return result
            
        except Exception as e:
            print(f"❌ Prediction error: {e}")
            import traceback
            traceback.print_exc()
            return None
