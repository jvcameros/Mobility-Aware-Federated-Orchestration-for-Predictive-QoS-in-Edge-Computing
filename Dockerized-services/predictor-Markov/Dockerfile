FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

COPY apt.txt .
RUN apt-get update && \
    xargs -a apt.txt apt-get install -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY predictor.py .
COPY app/ ./app/
COPY entrypoint.sh .

EXPOSE 1000
CMD ["./entrypoint.sh"]

