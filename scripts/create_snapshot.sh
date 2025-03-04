#!/bin/bash

# Set main variables
PROJECT_ID="PROJECT_ID_HERE"
LOCATION="LOCATION HERE" # example us-central1
BACKUP_RULE_ID="br"
BACKUP_PLAN_ASSOCIATION_ID="${vm}-bpa"

# List all VMs in the project
echo "Available VMs in project:"
gcloud compute instances list --project="$PROJECT_ID" --format="table(name,zone,status)"
echo ""

# Get VMs and create snapshots in one loop using gcloud's built-in filtering
gcloud compute instances list --project="$PROJECT_ID" --format="table[no-heading](name)" | while read -r vm; do
    echo "Creating snapshot for VM: $vm"
    
    gcloud alpha backup-dr backup-plan-associations trigger-backup "$BACKUP_PLAN_ASSOCIATION_ID" \
        --project="$PROJECT_ID" \
        --location="$LOCATION" \
        --workload-project="$PROJECT_ID" \
        --backup-rule-id="$BACKUP_RULE_ID" \
        --no-async \
        --format="json" || {
            echo "Failed to create snapshot for $vm"
            exit 1
        }
done

# Delete the backup plan association and backup plan to prevent further snapshots,
# we're only interested in one snapshot per VM, keep that for x days and remove
./delete_backup_plan_association.sh
./delete_backup_plan.sh