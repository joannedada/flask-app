# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the application code into the container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 5000 for Flask
EXPOSE 5000

# Set environment variables for database connection
ENV DB_HOST=localhost
ENV DB_NAME=devopsdb
ENV DB_USER=devops
ENV DB_PASS=password

# Run the Flask app
CMD ["python", "app.py"]

