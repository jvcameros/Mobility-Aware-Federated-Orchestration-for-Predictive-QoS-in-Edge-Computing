import asyncio
import numpy as np
from app.model_loader import model, scaler
from typing import List


class PredictionBatcher:
    def __init__(self, batch_window_sec=1.0):
        self.requests = []
        self.lock = asyncio.Lock()
        self.batch_window = batch_window_sec

    async def add_requests(self, reqs):
        async with self.lock:
            self.requests.extend(reqs)
            if len(self.requests) == len(reqs):
                await asyncio.sleep(self.batch_window)
                batch = self.requests.copy()
                self.requests.clear()

        sequences = np.array([r.sequence for r in batch])
        uids = np.array([[r.uid] for r in batch])

        preds = model.predict({'sequence_input': sequences, 'uid_input': uids})
        preds_unscaled = scaler.inverse_transform(preds).tolist()
        return preds_unscaled


class PredictionRequest:
    def __init__(self, uid: int, sequence: List[List[float]]):
        self.uid = uid
        self.sequence = sequence
