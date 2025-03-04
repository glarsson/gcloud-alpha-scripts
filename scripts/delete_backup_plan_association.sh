#!/bin/bash

# Set main variables
PROJECT_ID="PROJECT_ID_HERE"
LOCATION="LOCATION HERE" # example us-central1
BACKUP_PLAN="bp"

# Check if there are any existing backup plan associations
if gcloud alpha backup-dr backup-plan-associations list --project="$PROJECT_ID" | grep -q "Listed 0 items."; then
    echo "No backup plan associations found. Exiting script."
    exit 1
fi

# Delete backup plan associations using gcloud's built-in formatting to find the VMs
gcloud compute instances list --project="$PROJECT_ID" \
    --format="table[no-heading](name)" | while read -r vm; do
    echo "Deleting backup plan association for VM: $vm"
    
    gcloud alpha backup-dr backup-plan-associations delete "${vm}-bpa" \
        --location="$LOCATION" \
        --project="$PROJECT_ID" \
        --quiet \
        --no-async \
        --format="json" || {
            echo "Failed to delete backup plan association for $vm"
            exit 1
        }
done
