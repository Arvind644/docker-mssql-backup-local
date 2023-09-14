#! /usr/bin/env bash


# Uses the docker-compose container's name
# DATABASE_NAME=$1
# CONTAINER_NAME=${2:-"core-db-1"}
DATABASE_NAME="msdb"
CONTAINER_NAME="testcontainer"

# if [ -z $CONTAINER_NAME ]
# then
#   echo "Usage: $0 [database name] [container name]"
#   exit 1
# fi

# if [ -z $DATABASE_NAME ]
# then
#   echo "Usage: $0 [database name] [container name] "
#   exit 1
# fi

# Set bash to exit if any further command fails
set -e
set -o pipefail

# Create a file name for the backup based on the current date and time
# Example: 2019-01-27_13:42:00.master.bak
FILE_NAME=$(date +%Y-%m-%d_%H:%M:%S.$DATABASE_NAME.bak)

# Make sure the backups folder exists on the host file system
#mkdir -p "./backups"


echo "Backing up database '$DATABASE_NAME' from container '$CONTAINER_NAME'..."

# Create a database backup with sqlcmd
/opt/mssql-tools18/bin/sqlcmd -b -V16 -S tcp:sqlserver,1433 -U SA -P 'Testing@1122' -C -Q "BACKUP DATABASE [$DATABASE_NAME] TO DISK = N'/var/opt/mssql/backups/$FILE_NAME' with NOFORMAT, NOINIT, NAME = '$DATABASE_NAME-full', SKIP, NOREWIND, NOUNLOAD, STATS = 10"

echo ""
echo "Exporting file from container..."

# Copy the created file out of the container to the host filesystem
cp /backups/backups/$FILE_NAME /host-backups/$FILE_NAME

echo "Backed up database '$DATABASE_NAME' to ./backups/$FILE_NAME"
echo "Done!"