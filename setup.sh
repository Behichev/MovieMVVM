#!/bin/bash

# Path to the configuration files
CONFIG_PATH="NetworkApp/Config/Secrets.xcconfig"
EXAMPLE_PATH="NetworkApp/Config/SecretsExample.xcconfig"

# Check if the main configuration file exists
if [ ! -f "$CONFIG_PATH" ]; then
    echo "✅ Creating $CONFIG_PATH based on $EXAMPLE_PATH ..."
    cp "$EXAMPLE_PATH" "$CONFIG_PATH"
    echo "🔐 WARNING: Fill in your real values in $CONFIG_PATH"
else
    echo "ℹ️ $CONFIG_PATH already exists. Skipping copy."
fi