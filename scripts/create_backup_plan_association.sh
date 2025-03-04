#!/bin/bash

# Set main variables
PROJECT_ID="PROJECT_ID_HERE"
LOCATION="LOCATION HERE" # example us-central1
BACKUP_PLAN="bp"

# Check if backup plan associations already exist
if gcloud alpha backup-dr backup-plan-associations list --project="$PROJECT_ID" | grep "Listed 0 items."; then
    echo "Backup plan association already exists. Exiting script."
    exit 1
fi

# List all VMs in the project
echo "Available VMs in project:"
gcloud compute instances list --project="$PROJECT_ID" --format="table(name,zone,status)"
echo ""

# Create backup plan associations using gcloud's built-in formatting to find the VMs
gcloud compute instances list --project="$PROJECT_ID" \
    --format="csv[no-heading](name,zone)" | while IFS=, read -r vm zone; do
    echo "Creating backup plan association for VM: $vm"
    
    gcloud alpha backup-dr backup-plan-associations create "${vm}-bpa" \
        --backup-plan="$BACKUP_PLAN" \
        --location="$LOCATION" \
        --project="$PROJECT_ID" \
        --resource="projects/$PROJECT_ID/zones/$zone/instances/$vm" \
        --resource-type="compute.googleapis.com/Instance" \
        --no-async \
        --format="json" || {
            echo "Failed to create backup plan association for $vm"
            exit 1
        }
done