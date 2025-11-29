#!/bin/bash

# Setup script for git credential helper
# This configures git to use the credential helper script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPER_SCRIPT="$SCRIPT_DIR/git-credential-helper.sh"

# Make the helper script executable
chmod +x "$HELPER_SCRIPT"

# Get absolute path to helper script
ABS_HELPER_PATH="$(realpath "$HELPER_SCRIPT")"

# Configure git to use the credential helper
echo "Configuring git to use credential helper..."
git config --global credential.helper "!$ABS_HELPER_PATH"

echo "Setup complete!"
echo ""
echo "The credential helper is now active."
echo "Credentials will be stored in: $HOME/.git-credentials-store/keys.txt"
echo ""
echo "To test, try cloning a private repository or pushing to one."
echo "Your credentials will be automatically saved."

