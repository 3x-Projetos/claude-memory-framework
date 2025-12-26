#!/bin/bash
#
# Claude Memory Cloud - Local Setup Script
#
# This script clones the cloud memory repo and sets up initial structure
# Run this on your local machine (Windows/Linux/Mac)
#
# Usage:
#   bash .claude/setup-cloud-memory.sh
#

set -e

CLOUD_REPO="https://github.com/3x-Projetos/claude-memory-cloud.git"
CLOUD_DIR="$HOME/.claude-memory-cloud"

echo "=========================================="
echo "Claude Memory Cloud - Setup"
echo "=========================================="
echo ""

# Check if already exists
if [ -d "$CLOUD_DIR" ]; then
    echo "⚠️  Directory $CLOUD_DIR already exists!"
    echo ""
    read -p "Do you want to remove it and start fresh? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Removing existing directory..."
        rm -rf "$CLOUD_DIR"
    else
        echo "Aborted. Please backup/move the existing directory first."
        exit 1
    fi
fi

echo "📥 Cloning cloud memory repository..."
git clone "$CLOUD_REPO" "$CLOUD_DIR"

echo ""
echo "📁 Navigating to cloud directory..."
cd "$CLOUD_DIR"

echo ""
echo "✅ Cloud memory repository cloned successfully!"
echo ""
echo "📍 Location: $CLOUD_DIR"
echo "🔗 Remote: $CLOUD_REPO"
echo ""

# Check if repo is empty (just .git directory)
FILE_COUNT=$(find . -maxdepth 1 -not -path . -not -path ./.git -not -path './.git/*' | wc -l)

if [ "$FILE_COUNT" -eq 0 ]; then
    echo "📝 Repository is empty. Initializing structure..."
    echo ""

    # This script will be updated with file creation commands
    # after you run it the first time and populate manually

    echo "⚠️  The repository on GitHub is currently empty."
    echo ""
    echo "Next steps:"
    echo "1. I'll provide you with all the files to create"
    echo "2. Copy them into $CLOUD_DIR"
    echo "3. Run: cd $CLOUD_DIR && git add . && git commit -m 'Initial commit' && git push"
    echo ""
else
    echo "✅ Repository already has files. You're all set!"
fi

echo ""
echo "=========================================="
echo "Setup complete!"
echo "=========================================="
echo ""
echo "To verify:"
echo "  cd ~/.claude-memory-cloud"
echo "  git status"
echo ""
