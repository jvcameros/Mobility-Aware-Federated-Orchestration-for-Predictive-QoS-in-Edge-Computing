# Use a Python base image
FROM python:3.10-buster

# Set the working directory
WORKDIR /redis-publisher

# Copy the Python code for the Redis Publisher Service
COPY ./redis_publisher.py .

# Copy the requirements file
COPY ./requirements.txt .

# Install dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the Redis port
EXPOSE 6379

# Run the Redis Publisher (this is assuming you have a script to run it, adjust as necessary)
CMD ["python", "redis_publisher.py"]

