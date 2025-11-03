#!/bin/bash

# Script to wait until all attached Longhorn volumes are healthy

set -e

while true; do
    volumes=$(kubectl -n storage get volumes.longhorn.io -o json)
    attached_volumes=$(echo "$volumes" | jq -r '.items[] | select(.status.state=="attached") | {name: .metadata.name, health: .status.robustness}')
    unhealthy_volumes=$(echo "$attached_volumes" | jq -r 'select(.health != "healthy") | .name')

    if [[ -z "$unhealthy_volumes" ]]; then
        echo "All attached Longhorn volumes are healthy."
        exit 0
    else
        echo "Waiting for the following volumes to become healthy:"
        echo "$unhealthy_volumes"
        sleep 60
    fi
done
