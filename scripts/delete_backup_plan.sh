#!/bin/bash

# Set main variables
PROJECT_ID="PROJECT_ID_HERE"
LOCATION="LOCATION HERE" # example us-central1
BACKUP_PLAN_ID="bp"

# 
if  ! gcloud alpha backup-dr backup-plans list --project="$PROJECT_ID" --location="$LOCATION" | grep -q "ACTIVE"; then
    echo "Found no backup plan to delete."
    exit 1
fi

# Delete backup plan
gcloud alpha backup-dr backup-plans delete "$BACKUP_PLAN_ID" \
    --location="$LOCATION" \
    --project="$PROJECT_ID" \
    --quiet \
    --no-async \
    --format="json"
