# gcloud-alpha-scripts
A collection of scripts to do things with snapshots in bash script form but the main part is the gcloud commands

## It's a help for you guys looking for some more examples of the usage of gcloud alpha backupdr commands.

## How to use
(I was using cloud shell to run the scripts)
1. Enable the backupdr API for the project, I believe this is free
2. Clone the repository
3. Edit the PROJECT_ID and LOCATION settings to your liking of course

The scripts assume than you want to create a single snapshot for all VMs in the project and then when you run 

```
create_snapshot.sh
```

 it will create a snapshot for each VM and then delete the backup plan and backup plan association so that there is only one snapshot per VM (otherwise it starts a schedule - this part can definitely be improved).

## The order the scripts need to be run to create all the neccessary bits and pieces:
1. create_backup_vault.sh
2. create_backup_plan.sh
3. create_backup_plan_association.sh
4. create_snapshot.sh

## The opposite order should be used to delete the neccessary bits and pieces:
1. delete_snapshot.sh
2. delete_backup_plan_association.sh
3. delete_backup_plan.sh
4. delete_backup_vault.sh

Please note that currently the snapshots are set to be retained for 3 days, so if you run the delete_snapshot.sh script earlier than 3 days have passed it will fail. but you can just run it again after three days and it will work, then you can continue with the reverse steps to remove everything if you wish, or mess around with the retention policy.

Good luck :)

 



