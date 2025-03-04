#!/bin/bash

# Set main variables
PROJECT_ID="PROJECT_ID_HERE"
LOCATION="LOCATION HERE" # example us-central1
BACKUP_RULE_ID="br"
BACKUP_VAULT_ID="${PROJECT_ID}-bv"

# Get datasource name
DATASOURCE_NAME=$(gcloud alpha backup-dr data-sources list --project=$PROJECT_ID --location=$LOCATION --format="value(name)" | grep $PROJECT_ID)

# Get all backup names and store them in an array
BACKUP_NAMES=($(gcloud alpha backup-dr backups list --project=$PROJECT_ID \
--location=$LOCATION \
--data-source=$DATASOURCE_NAME \
--backup-vault=$BACKUP_VAULT_ID \
--format="value(name)"))

# Loop through each backup name and delete it
for BACKUP_NAME in "${BACKUP_NAMES[@]}"; do
    echo "Deleting backup: $BACKUP_NAME"
    
    # Print the list of backups found (for debugging)
    echo "Found ${#BACKUP_NAMES[@]} backups to delete"
    
    gcloud alpha backup-dr backups delete "$BACKUP_NAME" \
    --project=$PROJECT_ID \
    --location=$LOCATION \
    --data-source=$DATASOURCE_NAME \
    --backup-vault=$BACKUP_VAULT_ID \
    --quiet \
    --no-async \
    --format="json" || echo "Failed to delete backup: $BACKUP_NAME"
done

# Check if no backups were found
if [ ${#BACKUP_NAMES[@]} -eq 0 ]; then
    echo "No backups found to delete"
fi
