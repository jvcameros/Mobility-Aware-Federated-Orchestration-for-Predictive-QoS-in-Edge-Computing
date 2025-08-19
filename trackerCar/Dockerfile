# gateway/Dockerfile
FROM python:3.11-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el código fuente
COPY trackerCar.py .

# Instalar dependencias
RUN pip install --no-cache-dir fastapi uvicorn[standard] httpx 
RUN apt-get update && apt-get install -y curl dnsutils && apt-get clean && rm -rf /var/lib/apt/lists/*

# Exponer el puerto donde se ejecuta el servicio
EXPOSE 8000

# Comando de arranque
CMD ["uvicorn", "trackerCar:app", "--host", "0.0.0.0", "--port", "8000"]
