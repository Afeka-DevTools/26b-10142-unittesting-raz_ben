#!/bin/bash

set -e
set -o pipefail

MYSQL_CONTAINER="afeka-mysql-db"
BACKUP_DIR="backups"
BACKUP_FILE="$BACKUP_DIR/my-drupal.backup.sql.gz"
TEMP_FILE="$BACKUP_FILE.tmp"

container_is_running() {
    docker ps --format '{{.Names}}' | grep -qx "$1"
}

echo "מתחיל גיבוי של מסד הנתונים..."

if ! container_is_running "$MYSQL_CONTAINER"; then
    echo "שגיאה: קונטיינר MySQL בשם $MYSQL_CONTAINER אינו רץ."
    echo "יש להריץ קודם את ./setup.sh או להפעיל את הקונטיינר."
    exit 1
fi

mkdir -p "$BACKUP_DIR"

if docker exec "$MYSQL_CONTAINER" sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' | gzip > "$TEMP_FILE"; then
    mv "$TEMP_FILE" "$BACKUP_FILE"
    echo "הגיבוי נוצר בהצלחה: $BACKUP_FILE"
else
    rm -f "$TEMP_FILE"
    echo "שגיאה: הגיבוי נכשל."
    exit 1
fi
