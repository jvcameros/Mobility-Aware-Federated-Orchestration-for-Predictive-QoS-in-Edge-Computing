# Base image
FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gcc \
    libffi-dev \
    libssl-dev \
    python3-dev \
    build-essential \
    libpq-dev \
    git \
    jq \
    openssh-client \
    time \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    fastapi \
    uvicorn \
    python-openstackclient

RUN mkdir -p /root/.config/openstack
COPY clouds.yaml /root/.config/openstack/clouds.yaml

COPY orchestrator.py .
COPY edge_servers.json .
COPY comparator.py .
COPY pops_boundaries.json .
COPY node_migrator.py .
COPY operations/ .
COPY keyshare .
COPY entrypoint.sh .

RUN chmod +x /app/entrypoint.sh

EXPOSE 1000
CMD ["./entrypoint.sh"]


#container built using the following command. Solved problems of pushing.
#docker build --compress -t jvcameros/orchestrator-full:latest .
