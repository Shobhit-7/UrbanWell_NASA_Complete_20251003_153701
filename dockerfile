# Use official Python image
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Copy requirements (agar requirements.txt available hai)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files
COPY . .

# Expose Flask default port
EXPOSE 5000

# Environment variable to tell Flask app location
ENV FLASK_APP=urbanwell_backend.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_ENV=development

# Command to run the Flask app
CMD ["flask", "run"]
