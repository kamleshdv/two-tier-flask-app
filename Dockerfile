# Base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies required by flask_mysqldb / mysqlclient
RUN apt-get update && apt-get install -y \
    gcc \
    pkg-config \
    default-libmysqlclient-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies first (better layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose Flask port
EXPOSE 5000

# Environment variables (override at runtime)
ENV MYSQL_HOST=localhost
ENV MYSQL_USER=default_user
ENV MYSQL_PASSWORD=default_password
ENV MYSQL_DB=default_db

# Run the Flask app
CMD ["python", "app.py"]
