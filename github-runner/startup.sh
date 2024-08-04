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
if [ $DOCKER_GROUP ]
then
    echo "Adding User to Existing Docker Group"
    usermod -aG $DOCKER_GROUP $RUNUSER
    newgrp $DOCKER_GROUP
else
    echo "Creating Group and User based on docker socket uid and gid"
    groupadd -g ${DOCKER_GID} dind
    usermod -aG dind $RUNUSER
    newgrp dind
fi

# Create Working Directory
echo "Create/Change Owner for Work Directory"
mkdir -p $WORKDIR
chown -R ${RUNUSER} $WORKDIR

# tail -f /dev/null
# su runner -c "docker ps"

su $RUNUSER -c "./config.sh --unattended --url $REPO_URL --token $RUNNER_TOKEN --work $WORKDIR"
su $RUNUSER -c "./run.sh"