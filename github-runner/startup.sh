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
DOCKER_SOCKET=/var/run/docker.sock
RUNUSER=runner

if [ -S ${DOCKER_SOCKET} ]; then
    DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})
    DOCKER_GROUP=$(getent group ${DOCKER_GID} | awk -F ":" '{ print $1 }')
    if [ $DOCKER_GROUP ]
    then
        usermod -aG $DOCKER_GROUP $RUNUSER
    else
        groupadd -g ${DOCKER_GID} docker-admin
        usermod -aG docker-admin $RUNUSER
    fi
fi


# Create Working Directory
mkdir -p $WORKDIR
chown -R ${RUNUSER} $WORKDIR

# tail -f /dev/null

su $RUNUSER -c "./config.sh --unattended --url $REPO_URL --token $RUNNER_TOKEN --work $WORKDIR"
su $RUNUSER -c "./run.sh"