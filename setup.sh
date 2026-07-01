#!/bin/bash

set -e

NETWORK_NAME="afeka-drupal-network"
MYSQL_CONTAINER="afeka-mysql-db"
DRUPAL_CONTAINER="afeka-drupal-site"
MYSQL_VOLUME="afeka-mysql-data"
DRUPAL_VOLUME="afeka-drupal-data"

MYSQL_ROOT_PASSWORD="my-secret-pw"
MYSQL_DATABASE="drupal_db"
MYSQL_USER="drupal_user"
MYSQL_PASSWORD="drupal_pass"

container_exists() {
    docker ps -a --format '{{.Names}}' | grep -qx "$1"
}

remove_old_container() {
    local container_name="$1"

    if container_exists "$container_name"; then
        echo "נמצא קונטיינר ישן בשם $container_name. עוצר ומסיר אותו לפני הקמה מחדש..."
        docker stop "$container_name" >/dev/null 2>&1 || true
        docker rm "$container_name" >/dev/null
    fi
}

echo "מתחיל הקמת סביבת Drupal עם Docker..."

if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "הרשת $NETWORK_NAME כבר קיימת."
else
    echo "יוצר רשת Docker בשם $NETWORK_NAME..."
    docker network create "$NETWORK_NAME" >/dev/null
fi

echo "מוודא שקיימים volumes של הפרויקט..."
docker volume create "$MYSQL_VOLUME" >/dev/null
docker volume create "$DRUPAL_VOLUME" >/dev/null

remove_old_container "$MYSQL_CONTAINER"
remove_old_container "$DRUPAL_CONTAINER"

echo "מקים קונטיינר MySQL בשם $MYSQL_CONTAINER..."
docker run -d \
    --name "$MYSQL_CONTAINER" \
    --network "$NETWORK_NAME" \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
    -e MYSQL_DATABASE="$MYSQL_DATABASE" \
    -e MYSQL_USER="$MYSQL_USER" \
    -e MYSQL_PASSWORD="$MYSQL_PASSWORD" \
    -v "$MYSQL_VOLUME":/var/lib/mysql \
    mysql:latest >/dev/null

echo "ממתין כמה שניות כדי ש-MySQL יתחיל לעבוד..."
sleep 10

echo "מקים קונטיינר Drupal בשם $DRUPAL_CONTAINER..."
docker run -d \
    --name "$DRUPAL_CONTAINER" \
    --network "$NETWORK_NAME" \
    -p 8080:80 \
    -v "$DRUPAL_VOLUME":/var/www/html \
    drupal:latest >/dev/null

echo ""
echo "הסביבה הוקמה בהצלחה."
echo ""
echo "פתחו את Drupal בדפדפן:"
echo "http://localhost:8080"
echo ""
echo "פרטי מסד הנתונים להתקנת Drupal:"
echo "Database type: MySQL"
echo "Database host: afeka-mysql-db"
echo "Database port: 3306"
echo "Database name: drupal_db"
echo "Database user: drupal_user"
echo "Database password: drupal_pass"
echo ""
echo "פרטי האתר:"
echo "Site name: האתר של רז מצליח ובן פישר"
echo "Admin username: demoadmin"
echo "Admin password: secretpass"
