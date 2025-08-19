FROM python:3.10-buster

WORKDIR /proxy

COPY ./proxy.py .

COPY ./requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

CMD ["python", "proxy.py","--port","8000"]
