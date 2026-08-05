#!/usr/bin/env bash

set -euo pipefail

MYSQL_CONTAINER="afeka-mysql-db"
DRUPAL_CONTAINER="afeka-drupal-site"
BACKUP_DIR="backups"
SQL_BACKUP_FILE="$BACKUP_DIR/my-drupal.backup.sql.gz"
SITES_BACKUP_FILE="$BACKUP_DIR/drupal-sites.backup.tar.gz"
SQL_TEMP_FILE=""
SITES_TEMP_FILE=""

container_is_running() {
    docker ps --format '{{.Names}}' | grep -qx "$1"
}

remove_temporary_backups() {
    if [ -n "$SQL_TEMP_FILE" ]; then
        rm -f -- "$SQL_TEMP_FILE"
    fi

    if [ -n "$SITES_TEMP_FILE" ]; then
        rm -f -- "$SITES_TEMP_FILE"
    fi
}

trap remove_temporary_backups EXIT

echo "מתחיל גיבוי של מסד הנתונים ושל קובצי Drupal..."

if ! container_is_running "$MYSQL_CONTAINER"; then
    echo "שגיאה: קונטיינר MySQL בשם $MYSQL_CONTAINER אינו רץ."
    echo "יש להריץ קודם את ./setup.sh או להפעיל את הקונטיינר."
    exit 1
fi

if ! container_is_running "$DRUPAL_CONTAINER"; then
    echo "שגיאה: קונטיינר Drupal בשם $DRUPAL_CONTAINER אינו רץ."
    echo "יש להריץ קודם את ./setup.sh או להפעיל את הקונטיינר."
    exit 1
fi

mkdir -p "$BACKUP_DIR"
SQL_TEMP_FILE="$(mktemp "$BACKUP_DIR/.my-drupal.backup.sql.gz.XXXXXX")"
SITES_TEMP_FILE="$(mktemp "$BACKUP_DIR/.drupal-sites.backup.tar.gz.XXXXXX")"

echo "מגבה את כל מסדי הנתונים של MySQL..."
if ! docker exec "$MYSQL_CONTAINER" sh -c 'exec mysqldump --single-transaction --quick --lock-tables=false --all-databases --triggers --routines --events --set-gtid-purged=OFF -uroot -p"$MYSQL_ROOT_PASSWORD"' | gzip > "$SQL_TEMP_FILE"; then
    echo "שגיאה: גיבוי מסד הנתונים נכשל."
    exit 1
fi

if [ ! -s "$SQL_TEMP_FILE" ] || ! gzip -t "$SQL_TEMP_FILE"; then
    echo "שגיאה: קובץ גיבוי מסד הנתונים אינו תקין."
    exit 1
fi

if ! gzip -cd "$SQL_TEMP_FILE" | grep -E '^(CREATE TABLE|INSERT INTO)' >/dev/null; then
    echo "שגיאה: גיבוי מסד הנתונים אינו מכיל מבני נתונים אמיתיים."
    exit 1
fi

echo "מגבה את כל קובצי ה-volume של Drupal..."
if ! docker exec "$DRUPAL_CONTAINER" tar -czf - -C /var/www/html . > "$SITES_TEMP_FILE"; then
    echo "שגיאה: גיבוי קובצי Drupal נכשל."
    exit 1
fi

if [ ! -s "$SITES_TEMP_FILE" ] || ! tar -tzf "$SITES_TEMP_FILE" >/dev/null; then
    echo "שגיאה: ארכיון קובצי Drupal אינו תקין."
    exit 1
fi

if ! tar -tzf "$SITES_TEMP_FILE" | grep -E '^\./(index\.php|core/|sites/)' >/dev/null; then
    echo "שגיאה: ארכיון הקבצים אינו מכיל את קובצי Drupal הצפויים."
    exit 1
fi

mv -- "$SQL_TEMP_FILE" "$SQL_BACKUP_FILE"
SQL_TEMP_FILE=""
mv -- "$SITES_TEMP_FILE" "$SITES_BACKUP_FILE"
SITES_TEMP_FILE=""

echo "הגיבויים נוצרו ואומתו בהצלחה:"
echo "- $SQL_BACKUP_FILE"
echo "- $SITES_BACKUP_FILE"
