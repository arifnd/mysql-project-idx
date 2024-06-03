#!/bin/bash

# Get the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/data"
CNF_FILE="$SCRIPT_DIR/my.cnf"
MYSQLD_CMD="mysqld --defaults-file=$CNF_FILE"
FORCE_RECREATE=false

# Check for the --force option
if [[ "$1" == "--force" ]]; then
    FORCE_RECREATE=true
fi

# Create data folder if it does not exist or if force recreate is true
if [[ ! -d "$DATA_DIR" || "$FORCE_RECREATE" == true ]]; then
    echo "Creating data directory..."
    rm -rf "$DATA_DIR"  # Remove existing directory if forcing recreation
    mkdir -p "$DATA_DIR"

    # Create my.cnf file with the specified configuration
    cat > "$CNF_FILE" <<EOL
[mysqld]
user=user

datadir=$DATA_DIR
socket=$DATA_DIR/mysql.sock
log-error=$DATA_DIR/mysql-error.log
pid-file=$DATA_DIR/mysql.pid
EOL

    # Initialize MySQL data directory
    echo "Initializing MySQL data directory..."

    if ! command -v mysqld > /dev/null
    then
        echo "Error: mysqld command not found"
        exit 1
    else
        $MYSQLD_CMD --initialize
    fi

    # Start MySQL server for initial setup
    echo "Starting MySQL server for initial setup..."
    $MYSQLD_CMD &
    MYSQLD_PID=$!
    sleep 10  # Wait for MySQL server to start

    # Extract the temporary password from the log file
    TEMP_PASSWORD=$(grep "temporary password" $DATA_DIR/mysql-error.log | awk '{print $NF}')

    # Change the root password using the extracted temporary password
    echo "Changing root password..."
    mysql -u root --socket=$DATA_DIR/mysql.sock --password="$TEMP_PASSWORD" --connect-expired-password --execute="ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';"
    mysqladmin -u root --password='123456' --socket=$DATA_DIR/mysql.sock shutdown

    # Wait for MySQL server to shut down
    wait $MYSQLD_PID

    echo "Initial setup complete."
else
    echo "Data directory already exists. Skipping initialization."
fi

# Start MySQL server
if pgrep mysqld > /dev/null
then
    echo "MySQL server is already running"
else
    echo "Starting MySQL server..."
    if [[ "$1" == "-d" ]]; then
        $MYSQLD_CMD &
    else
        $MYSQLD_CMD
    fi
    exit_status=$?
    if [ $exit_status -eq 1 ]; then
        echo "Failed to start MySQL server with exit status $exit_status."
        exit $exit_status
    fi
fi