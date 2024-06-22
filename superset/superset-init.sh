#!/bin/bash

# Upgrade the database
superset db upgrade

# Create default roles and permissions
superset init

# Check if the admin user already exists
if ! superset fab list-users | grep -q "admin"; then
    # Create an admin user (adjust values accordingly)
    superset fab create-admin \
      --username admin \
      --firstname Superset \
      --lastname Admin \
      --email admin@superset.com \
      --password admin
fi

# Load some data to play with (optional)
superset load_examples
