# Docker configuration file that defines the container environment
# Specifies base image, working directory, dependencies, and startup command
# Creates a portable and consistent environment for the Flask application

# Use an official Python runtime as a parent image
FROM python:3.9-slim  # Base image: Python 3.9 lightweight version

# Set working directory
WORKDIR /app  # All commands will run in /app directory

# Copy requirements and install
COPY requirements.txt .  # Copy dependencies file first (for build caching)
RUN pip install --no-cache-dir -r requirements.txt  # Install dependencies

# Copy source code
COPY . .  # Copy all application files to container

# Expose port
EXPOSE 5000  # Document that container listens on port 5000

# Run the application
CMD ["python", "app.py"]  # Command to execute when container starts
