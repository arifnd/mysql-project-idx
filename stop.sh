#!/bin/bash

if pgrep mysqld > /dev/null
then
    echo "Stopping MySQL server..."
    ps -a | grep mysqld | grep -v grep | awk '{print $1}' | xargs kill -9
    echo "MySQL server stopped successfully."
else
    echo "No MySQL server is running."
fi