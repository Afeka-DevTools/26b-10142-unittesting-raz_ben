#!/bin/bash

NETWORK_NAME="afeka-drupal-network"
MYSQL_CONTAINER="afeka-mysql-db"
DRUPAL_CONTAINER="afeka-drupal-site"
MYSQL_VOLUME="afeka-mysql-data"
DRUPAL_VOLUME="afeka-drupal-data"
MYSQL_IMAGE="mysql:8.4"
DRUPAL_IMAGE="drupal:11-apache"

container_exists() {
    docker ps -a --format '{{.Names}}' | grep -qx "$1"
}

volume_exists() {
    docker volume inspect "$1" >/dev/null 2>&1
}

image_exists() {
    docker image inspect "$1" >/dev/null 2>&1
}

echo "אזהרה: cleanup ימחק את סביבת Docker של הפרויקט."
echo "הפעולה מוחקת:"
echo "- קונטיינר Drupal: $DRUPAL_CONTAINER"
echo "- קונטיינר MySQL: $MYSQL_CONTAINER"
echo "- רשת Docker: $NETWORK_NAME"
echo "- Docker volumes: $MYSQL_VOLUME, $DRUPAL_VOLUME"
echo "- Docker images: $DRUPAL_IMAGE, $MYSQL_IMAGE"
echo ""
echo "כדי להמשיך הקלידו בדיוק: yes"
read -r answer

if [ "$answer" != "yes" ]; then
    echo "הפעולה בוטלה."
    exit 0
fi

for container_name in "$DRUPAL_CONTAINER" "$MYSQL_CONTAINER"; do
    if container_exists "$container_name"; then
        echo "עוצר ומוחק קונטיינר: $container_name"
        docker stop "$container_name" >/dev/null 2>&1 || true
        docker rm "$container_name" >/dev/null 2>&1 || true
    else
        echo "הקונטיינר $container_name לא קיים, מדלג."
    fi
done

if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "מוחק רשת Docker: $NETWORK_NAME"
    docker network rm "$NETWORK_NAME" >/dev/null 2>&1 || true
else
    echo "הרשת $NETWORK_NAME לא קיימת, מדלג."
fi

for volume_name in "$MYSQL_VOLUME" "$DRUPAL_VOLUME"; do
    if volume_exists "$volume_name"; then
        echo "מוחק volume: $volume_name"
        docker volume rm "$volume_name" >/dev/null 2>&1 || true
    else
        echo "ה-volume $volume_name לא קיים, מדלג."
    fi
done

for image_name in "$DRUPAL_IMAGE" "$MYSQL_IMAGE"; do
    if image_exists "$image_name"; then
        echo "מוחק image: $image_name"
        docker rmi "$image_name" >/dev/null 2>&1 || echo "לא ניתן למחוק את $image_name, ייתכן שהוא בשימוש."
    else
        echo "ה-image $image_name לא קיים, מדלג."
    fi
done

echo "ניקוי הפרויקט הסתיים."
