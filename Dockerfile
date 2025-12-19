# Use Python 3.11 slim image
FROM python:3.11-slim

# Install iptables for firewall management
RUN apt-get update && \
    apt-get install -y iptables iproute2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Copy firewall setup script
COPY firewall-setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/firewall-setup.sh

# Expose Flask port
EXPOSE 5000

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Run the Flask application
CMD ["flask", "run"]
