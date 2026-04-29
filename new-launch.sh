#!/bin/bash

# Usage: ./new-launch.sh "feature-name"
# Creates a new deployment folder with IDEA.md template ready to fill in.

if [ -z "$1" ]; then
  echo "Usage: ./new-launch.sh \"feature-name\""
  echo "Example: ./new-launch.sh \"instant-payouts\""
  exit 1
fi

FOLDER="deployments/$1"

if [ -d "$FOLDER" ]; then
  echo "Folder '$FOLDER' already exists. Choose a different name."
  exit 1
fi

mkdir -p "$FOLDER"
cp deployments/.template/IDEA.md "$FOLDER/IDEA.md"

echo ""
echo "✓ Created: $FOLDER"
echo ""
echo "Next steps:"
echo "  1. Fill in $FOLDER/IDEA.md with your product idea"
echo "  2. Open Claude Code in that folder"
echo "  3. Run: /project:pre-scope"
echo ""
echo "  Later, when your PRD is ready:"
echo "  4. Save it as $FOLDER/PRD.md"
echo "  5. Run: /project:launch-notes"
