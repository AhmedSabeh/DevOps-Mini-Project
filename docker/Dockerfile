# Base image
FROM python:3.9-slim

# Set working directory inside the container
WORKDIR /app

# Copy requirements first and install dependencies
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose Flask's port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]


