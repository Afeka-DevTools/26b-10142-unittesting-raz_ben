#!/bin/bash

set -e
set -o pipefail

MYSQL_CONTAINER="afeka-mysql-db"
DRUPAL_CONTAINER="afeka-drupal-site"
MYSQL_DATABASE="drupal_db"
BACKUP_FILE="backups/my-drupal.backup.sql.gz"

container_is_running() {
    docker ps --format '{{.Names}}' | grep -qx "$1"
}

container_exists() {
    docker ps -a --format '{{.Names}}' | grep -qx "$1"
}

echo "מתחיל שחזור של מסד הנתונים..."

if [ ! -f "$BACKUP_FILE" ]; then
    echo "שגיאה: קובץ הגיבוי לא נמצא: $BACKUP_FILE"
    echo "יש להריץ קודם את ./backup.sh כדי ליצור גיבוי אמיתי."
    exit 1
fi

if ! container_is_running "$MYSQL_CONTAINER"; then
    echo "שגיאה: קונטיינר MySQL בשם $MYSQL_CONTAINER אינו רץ."
    echo "יש להריץ קודם את ./setup.sh או להפעיל את הקונטיינר."
    exit 1
fi

if ! container_exists "$DRUPAL_CONTAINER"; then
    echo "שגיאה: קונטיינר Drupal בשם $DRUPAL_CONTAINER לא נמצא."
    echo "יש להריץ קודם את ./setup.sh."
    exit 1
fi

if gunzip < "$BACKUP_FILE" | docker exec -i "$MYSQL_CONTAINER" sh -c "exec mysql -uroot -p\"\$MYSQL_ROOT_PASSWORD\" --force \"$MYSQL_DATABASE\""; then
    echo "מסד הנתונים שוחזר בהצלחה."
else
    echo "שגיאה: השחזור נכשל."
    exit 1
fi

echo "מפעיל מחדש את קונטיינר Drupal..."
docker restart "$DRUPAL_CONTAINER" >/dev/null
echo "קונטיינר Drupal הופעל מחדש."
echo "השחזור הסתיים בהצלחה."
