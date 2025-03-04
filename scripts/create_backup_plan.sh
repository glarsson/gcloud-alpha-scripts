#!/bin/bash

# Set main variables
PROJECT_ID="PROJECT_ID_HERE"
LOCATION="LOCATION HERE" # example us-central1
BACKUP_VAULT="projects/$PROJECT_ID/locations/$LOCATION/backupVaults/$PROJECT_ID-bv" 
BACKUP_RULE_ID="br"
BACKUP_PLAN_ID="bp"

# Check if a plan exists
if gcloud alpha backup-dr backup-plans list --project="$PROJECT_ID"  | grep -q "STATUS: ACTIVE"; then
    echo "An active backup plan already exists. Exiting script."
    exit 1
fi

# Create a new backup plan
gcloud alpha backup-dr backup-plans create $BACKUP_PLAN_ID \
    --project=$PROJECT_ID \
    --location=$LOCATION \
    --resource-type "compute.googleapis.com/Instance" \
    --backup-vault "$BACKUP_VAULT" \
    --backup-rule rule-id=$BACKUP_RULE_ID,recurrence=DAILY,backup-window-start=0,backup-window-end=24,retention-days=1 \
    --no-async \
    --format="json"
