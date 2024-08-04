#!/bin/bash

# Check if REPO_URL environment variable is set
if [ -z "$REPO_URL" ]; then
  echo "Error: REPO_URL environment variable is not set."
  exit 1
fi

# Check if RUNNER_TOKEN environment variable is set
if [ -z "$RUNNER_TOKEN" ]; then
  echo "Error: RUNNER_TOKEN environment variable is not set."
  exit 1
fi

# Get the hostname
HOSTNAME=$(hostname)

RUNNER_NAME=${RUNNER_NAME:-$HOSTNAME}

./config.sh --name $RUNNER_NAME --url $REPO_URL --token $RUNNER_TOKEN --work ./work
./run.sh --name $RUNNER_NAME