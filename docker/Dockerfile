# Base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy app code from host to image
COPY ../app/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of the code
COPY ../app .

# Expose the port Flask will run on
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]

