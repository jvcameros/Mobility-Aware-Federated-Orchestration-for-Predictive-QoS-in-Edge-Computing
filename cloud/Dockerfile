FROM python:3.10-buster

WORKDIR /cloud_service

COPY ./cloud_service.py .

COPY ./requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 6000

CMD ["python", "cloud_service.py","--port","6000"]
