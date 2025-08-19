FROM python:3.10-buster

WORKDIR /app

COPY edge_service_edge.py .

COPY ./requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["uvicorn", "edge_service_edge:app", "--host", "0.0.0.0", "--port", "5000"]
