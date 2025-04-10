#!/bin/bash

# Function to build Docker images
build_image() {
  local image_name=$1
  local version_tag=$2
  local build_context=$3

  echo "Building image: $image_name:$version_tag and $image_name:latest from $build_context"
  docker build -t "$image_name:$version_tag" -t "$image_name:latest" "$build_context"
}

# Function to push Docker images
push_image() {
  local image_name=$1

  echo "Pushing all tags for image: $image_name"
  docker push --all-tags "$image_name"
}

# Main logic for CLI parameter
if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <build|push>"
  exit 1
fi

action=$1

case $action in
  build)
    echo "Building Images"
    build_image "odytrice/cassandra" "5.0" "cassandra"
    build_image "odytrice/kafka" "3.7.0" "kafka"
    build_image "odytrice/github-runner" "2.317.1" "github-runner"
    build_image "odytrice/jupyterlab" "latest" "jupyterlab"
    build_image "odytrice/identity" "7.1.0" "identity"
    ;;
  push)
    echo "Pushing Images"
    push_image "odytrice/cassandra"
    push_image "odytrice/kafka"
    push_image "odytrice/github-runner"
    push_image "odytrice/jupyterlab"
    ;;
  *)
    echo "Invalid action: $action"
    echo "Usage: $0 <build|push>"
    exit 1
    ;;
esac