#!/bin/bash

if pgrep mysqld > /dev/null
then
     echo "MySQL server is already running"
else
    echo "No MySQL server is running."
fi