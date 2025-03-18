#!/bin/bash

# Check if REPO_URL environment variable is set
if [ -z "$REPO_URL" ]; then
  echo "Error: REPO_URL environment variable is not set."
  exit 1
fi

# Check if GITHUB_PAT environment variable is set
if [ -z "$GITHUB_PAT" ]; then
  echo "Error: GITHUB_PAT environment variable is not set."
  exit 1
fi

# Extract the owner and repository name from REPO_URL (assumes format https://github.com/owner/repo)
OWNER_REPO=${REPO_URL#https://github.com/}
OWNER=$(echo $OWNER_REPO | cut -d'/' -f1)
REPO=$(echo $OWNER_REPO | cut -d'/' -f2)

# Set the API URL for obtaining the runner registration token
API_URL="https://api.github.com/orgs/${OWNER}/actions/runners/registration-token"

echo "Generating runner token using GitHub PAT..."
RUNNER_TOKEN=$(curl -s -X POST -H "Authorization: Bearer $GITHUB_PAT" -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" $API_URL | jq -r '.token')

if [ -z "$RUNNER_TOKEN" ]; then
  echo "Error: Failed to retrieve runner token. Check your GITHUB_PAT permissions and REPO_URL."
  exit 1
fi

# Get the hostname and set runner name and working directory
HOSTNAME=$(hostname)
RUNNER_NAME=${RUNNER_NAME:-$HOSTNAME}
WORKDIR=${WORKDIR:-/home/runner/work}

# Add Docker Permissions
echo "Setting Docker Permissions"
DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GID=2375
RUNUSER=runner
if [ -S ${DOCKER_SOCKET} ]; then
    DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})
fi

DOCKER_GROUP=$(getent group ${DOCKER_GID} | awk -F ":" '{ print $1 }')
if [ $DOCKER_GROUP ]; then
    echo "Adding User to Existing Docker Group"
    usermod -aG $DOCKER_GROUP $RUNUSER
    newgrp $DOCKER_GROUP
else
    echo "Creating Group and User based on docker socket uid and gid"
    groupadd -g ${DOCKER_GID} dind
    usermod -aG dind $RUNUSER
    newgrp dind
fi

# Create Working Directory and change its owner
echo "Create/Change Owner for Work Directory"
mkdir -p $WORKDIR
chown -R ${RUNUSER} $WORKDIR

# Configure and start the GitHub runner as the specified user
su $RUNUSER -c ". ~/.profile"
su $RUNUSER -c "./config.sh --unattended --url $REPO_URL --token $RUNNER_TOKEN --work $WORKDIR"
su $RUNUSER -c "./run.sh"