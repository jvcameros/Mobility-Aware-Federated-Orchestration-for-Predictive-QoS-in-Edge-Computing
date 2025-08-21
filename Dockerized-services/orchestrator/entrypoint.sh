#!/bin/bash
set -e
./get-instances-info.sh &

python -u comparator.py &
python -u node_migrator.py &

uvicorn orchestrator:app --host 0.0.0.0 --port 1000


