#!/usr/bin/env bash

set -euo pipefail

MYSQL_CONTAINER="afeka-mysql-db"
DRUPAL_CONTAINER="afeka-drupal-site"
DRUPAL_VOLUME="afeka-drupal-data"
DRUPAL_IMAGE="drupal:latest"
SQL_BACKUP_FILE="backups/my-drupal.backup.sql.gz"
SITES_BACKUP_FILE="backups/drupal-sites.backup.tar.gz"

container_is_running() {
    docker ps --format '{{.Names}}' | grep -qx "$1"
}

container_exists() {
    docker ps -a --format '{{.Names}}' | grep -qx "$1"
}

echo "מתחיל שחזור מלא של Drupal ומסד הנתונים..."

if [ ! -s "$SQL_BACKUP_FILE" ] || [ ! -s "$SITES_BACKUP_FILE" ]; then
    echo "שגיאה: נדרשים שני קובצי גיבוי לא ריקים ב-$SQL_BACKUP_FILE וב-$SITES_BACKUP_FILE."
    echo "יש להריץ קודם את ./backup.sh כדי ליצור גיבוי אמיתי."
    exit 1
fi

if ! gzip -t "$SQL_BACKUP_FILE" || ! tar -tzf "$SITES_BACKUP_FILE" >/dev/null; then
    echo "שגיאה: אחד מקובצי הגיבוי אינו תקין. השחזור בוטל לפני שינוי הנתונים."
    exit 1
fi

if ! gzip -cd "$SQL_BACKUP_FILE" | grep -E '^(CREATE TABLE|INSERT INTO)' >/dev/null; then
    echo "שגיאה: גיבוי מסד הנתונים אינו מכיל מבני נתונים אמיתיים."
    exit 1
fi

if ! tar -tzf "$SITES_BACKUP_FILE" | grep -E '^\./(index\.php|core/|sites/)' >/dev/null; then
    echo "שגיאה: ארכיון הקבצים אינו מכיל את קובצי Drupal הצפויים."
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

echo "עוצר את Drupal לפני שחזור ה-volume..."
if container_is_running "$DRUPAL_CONTAINER"; then
    docker stop "$DRUPAL_CONTAINER" >/dev/null
fi

echo "מחליף את קובצי ה-volume בארכיון המאומת..."
docker run --rm --network none \
    -v "$DRUPAL_VOLUME":/volume \
    --entrypoint sh \
    "$DRUPAL_IMAGE" \
    -c 'find /volume -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +'
docker run --rm --network none -i \
    -v "$DRUPAL_VOLUME":/volume \
    --entrypoint tar \
    "$DRUPAL_IMAGE" \
    -xzf - -C /volume < "$SITES_BACKUP_FILE"

echo "משחזר את כל מסדי הנתונים של MySQL..."
if ! gunzip < "$SQL_BACKUP_FILE" | docker exec -i "$MYSQL_CONTAINER" sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"'; then
    echo "שגיאה: השחזור נכשל."
    exit 1
fi

echo "מפעיל את קונטיינר Drupal ומבצע restart לאחר השחזור..."
docker start "$DRUPAL_CONTAINER" >/dev/null
docker restart "$DRUPAL_CONTAINER" >/dev/null
echo "קונטיינר Drupal הופעל מחדש."
echo "השחזור הסתיים בהצלחה."
