#!/usr/bin/env bash

REPO_DIR="/home/abdu/Desktop/tp_devops"   
IMAGE_NAME="arithmetic-api:dev"
CONTAINER_NAME="arithmetic-api"
BRANCH="main"

cd $REPO_DIR

echo "Watching remote Git repo for new commits on branch $BRANCH..."

while true; do
    # Fetch remote updates
    git fetch origin $BRANCH

    LOCAL_COMMIT=$(git rev-parse $BRANCH)
    REMOTE_COMMIT=$(git rev-parse origin/$BRANCH)

    if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
        echo "New commit detected. Pulling changes and redeploying..."
        git pull origin $BRANCH

        # Stop & remove old container
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true

        # Build and run
        docker build -t $IMAGE_NAME .
        docker run --name $CONTAINER_NAME -d -p 5000:5000 $IMAGE_NAME

        echo "Deployment updated with latest commit: $REMOTE_COMMIT"
    fi

    sleep 30  # check every 30 seconds
done
