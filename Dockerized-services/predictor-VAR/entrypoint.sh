#!/bin/sh
set -e

echo "Starting orchestrator on cluster: ${CLUSTER_NAME:-unknown}"

uvicorn predictor:app --host 0.0.0.0 --port 1000
