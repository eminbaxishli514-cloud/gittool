#!/bin/bash

# Git Credential Helper Script
# Automatically stores git credentials in keys.txt

# Directory where keys.txt will be stored
KEYS_DIR="$HOME/.git-credentials-store"
KEYS_FILE="$KEYS_DIR/keys.txt"

# Create directory if it doesn't exist
mkdir -p "$KEYS_DIR"

# Initialize variables
protocol=""
host=""
path=""
username=""
password=""

# Read key=value pairs from stdin (git credential protocol)
while IFS= read -r line; do
    if [ -z "$line" ]; then
        # Empty line indicates end of input
        break
    fi
    
    # Parse the key=value pairs
    key=$(echo "$line" | cut -d'=' -f1)
    value=$(echo "$line" | cut -d'=' -f2-)
    
    case "$key" in
        protocol) protocol="$value" ;;
        host) host="$value" ;;
        path) path="$value" ;;
        username) username="$value" ;;
        password) password="$value" ;;
    esac
done

# Get the action (get, store, erase) - passed as first argument
action="$1"

case "$action" in
    get)
        # Try to retrieve credentials from keys.txt
        if [ -f "$KEYS_FILE" ]; then
            # Look for matching host
            while IFS= read -r stored_line; do
                if [ -n "$stored_line" ] && echo "$stored_line" | grep -q "host=$host"; then
                    # Output stored credentials in git credential format
                    # Parse key=value pairs from stored line
                    for pair in $stored_line; do
                        if echo "$pair" | grep -q "^protocol="; then
                            echo "$pair"
                        elif echo "$pair" | grep -q "^host="; then
                            echo "$pair"
                        elif echo "$pair" | grep -q "^path="; then
                            echo "$pair"
                        elif echo "$pair" | grep -q "^username="; then
                            echo "$pair"
                        elif echo "$pair" | grep -q "^password="; then
                            echo "$pair"
                        fi
                    done
                    exit 0
                fi
            done < "$KEYS_FILE"
        fi
        # If not found, output nothing (git will prompt)
        ;;
    
    store)
        # Store credentials in keys.txt
        if [ -n "$username" ] && [ -n "$password" ]; then
            timestamp=$(date '+%Y-%m-%d %H:%M:%S')
            entry="protocol=$protocol host=$host path=$path username=$username password=$password timestamp=$timestamp"
            
            # Remove old entry for this host if exists
            if [ -f "$KEYS_FILE" ]; then
                grep -v "host=$host" "$KEYS_FILE" > "$KEYS_FILE.tmp" 2>/dev/null || true
                mv "$KEYS_FILE.tmp" "$KEYS_FILE" 2>/dev/null || true
            fi
            
            # Append new entry
            echo "$entry" >> "$KEYS_FILE"
            chmod 600 "$KEYS_FILE"  # Secure the file
        fi
        ;;
    
    erase)
        # Remove credentials from keys.txt
        if [ -f "$KEYS_FILE" ]; then
            grep -v "host=$host" "$KEYS_FILE" > "$KEYS_FILE.tmp" 2>/dev/null || true
            mv "$KEYS_FILE.tmp" "$KEYS_FILE" 2>/dev/null || true
        fi
        ;;
esac

exit 0

