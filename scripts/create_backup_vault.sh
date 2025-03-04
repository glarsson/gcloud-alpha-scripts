#!/bin/bash

# Set main variables
PROJECT_ID="PROJECT_ID_HERE"
LOCATION="LOCATION HERE" # example us-central1
BACKUP_VAULT_ID="${PROJECT_ID}-bv"

# Check if an active backup vault exists
if gcloud alpha backup-dr backup-vaults list --project="$PROJECT_ID" | grep -q "STATUS: ACTIVE"; then
    echo "An active backup vault already exists. Exiting script."
    exit 1
fi

# Create a new backup vault
gcloud alpha backup-dr backup-vaults create $BACKUP_VAULT_ID \
   --location=$LOCATION \
   --project=$PROJECT_ID \
   --backup-min-enforced-retention="1d" \
   --no-async \
   --format="json"