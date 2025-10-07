#!/usr/bin/env bash

IMAGE_NAME="arithmetic-api:dev"
CONTAINER_NAME="arithmetic-api"

echo "Watching for file changes in $(pwd)..."

# Loop forever: wait for file changes and rebuild
while inotifywait -e modify,create,delete,move ./app.py ./requirements.txt; do
    echo "Change detected, rebuilding Docker image..."

    # Stop and remove old container (ignore errors if not running)
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true

    # Build the new image
    docker build -t $IMAGE_NAME .

    # Run new container
    docker run --name $CONTAINER_NAME -d -p 5000:5000 $IMAGE_NAME

    echo "Rebuilt & restarted container at http://127.0.0.1:5000"
done
