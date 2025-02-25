# Use Ubuntu as the base image
FROM ubuntu:22.04

# Update package lists and install necessary packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip libssl1.0

# Install AWS CLI using pip
RUN pip3 install awscli --user

# Set environment variables to ensure Python 3 is used by default
ENV PATH="/root/.local/bin:$PATH"

# Optional: Clean up unnecessary packages and files
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the sync script into the container
COPY sync.sh /sync.sh

# Make the script executable
RUN chmod +x /sync.sh

# Run the sync command once when the container starts
CMD ["/sync.sh"]