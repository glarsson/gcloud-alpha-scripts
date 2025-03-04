#!/bin/bash

# Set main variables
PROJECT_ID="PROJECT_ID_HERE"
LOCATION="LOCATION HERE" # example us-central1
BACKUP_VAULT_ID="${PROJECT_ID}-bv"

# Check if an active backup vault exists
if ! gcloud alpha backup-dr backup-vaults list --project="$PROJECT_ID" | grep "STATUS: ACTIVE"; then
    echo "No backup vault found. Exiting script."
    exit 1
fi

# Delete backup vault
gcloud alpha backup-dr backup-vaults delete "$BACKUP_VAULT_ID" \
    --location=$LOCATION \
    --project=$PROJECT_ID \
    --quiet \
    --no-async \
    --format="json"