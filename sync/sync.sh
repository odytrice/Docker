#!/bin/sh

# Check if PROVIDER is set
if [ -z "$PROVIDER" ]; then
    echo "Error: PROVIDER environment variable is not set."
    exit 1
fi

# Validate PROVIDER value
if [ "$PROVIDER" != "s3" ]; then
    echo "Error: Invalid PROVIDER. Only 'S3' is currently supported."
    exit 1
fi

# Check if DESTINATION_PATH is set
if [ -z "$DESTINATION_PATH" ]; then
    echo "Error: DESTINATION_PATH environment variable is not set."
    exit 1
fi

# Use environment variables for source and destination paths
SOURCE_PATH=${SOURCE_PATH:-"/data"}

echo "Syncing $SOURCE_PATH to $DESTINATION_PATH..."
aws s3 sync "$SOURCE_PATH" "$DESTINATION_PATH"