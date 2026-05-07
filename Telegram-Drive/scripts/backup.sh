#!/bin/sh
set -e

# Usage: ./scripts/backup.sh
BACKUPS_DIR=${BACKUPS_DIR:-/backups}
APP_DATA_DIR=${APP_DATA_DIR:-/data}
TIMESTAMP=$(date -u +"%Y%m%dT%H%M%SZ")
OUTFILE="$BACKUPS_DIR/telegram-drive-backup-$TIMESTAMP.tar.gz"

mkdir -p "$BACKUPS_DIR"
tar -czf "$OUTFILE" -C "$APP_DATA_DIR" .
echo "Backup created: $OUTFILE"

# Optional: upload to S3 if env vars are present
if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ] && [ -n "$BACKUP_S3_BUCKET" ]; then
  if command -v aws >/dev/null 2>&1; then
    aws s3 cp "$OUTFILE" "s3://$BACKUP_S3_BUCKET/" --only-show-errors
    echo "Backup uploaded to s3://$BACKUP_S3_BUCKET/"
  else
    echo "aws CLI not installed; skipping S3 upload"
  fi
fi
