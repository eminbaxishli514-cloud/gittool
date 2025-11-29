# Git Credential Helper for Kali Linux

This tool automatically detects and stores your git credentials (username and token/password) whenever you use git with private repositories.

## Features

- Automatically captures git credentials when you enter them
- Stores credentials securely in `~/.git-credentials-store/keys.txt`
- Works with all git operations (clone, push, pull, etc.)
- Remembers credentials for future use

## Installation

1. Make the setup script executable:
   ```bash
   chmod +x setup.sh
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```

This will configure git to use the credential helper automatically.

## How It Works

The script acts as a git credential helper that:
- **Detects** when you enter credentials (username/password or token)
- **Stores** them in `~/.git-credentials-store/keys.txt`
- **Retrieves** them automatically for future git operations

## Usage

After setup, just use git normally:

```bash
git clone https://github.com/username/private-repo.git
# Enter your username and token when prompted
# They will be automatically saved!

# Next time, no need to enter credentials again
git clone https://github.com/username/private-repo.git
```

## Viewing Stored Credentials

To view your stored credentials:
```bash
cat ~/.git-credentials-store/keys.txt
```

## Security Note

- The `keys.txt` file is created with permissions 600 (read/write for owner only)
- Keep your `keys.txt` file secure and never commit it to a repository
- Consider adding `~/.git-credentials-store/` to your `.gitignore` if you're working in a git repository

## Uninstallation

To remove the credential helper:
```bash
git config --global --unset credential.helper
```

## Troubleshooting

If credentials aren't being saved:
1. Check that the helper script is executable: `ls -l git-credential-helper.sh`
2. Verify git configuration: `git config --global --get credential.helper`
3. Check the keys directory exists: `ls -la ~/.git-credentials-store/`

