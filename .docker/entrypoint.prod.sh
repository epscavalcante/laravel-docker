#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-app}
env=${APP_ENV:-production}

echo "Enviroment: \"$env\""
echo "Role: \"$role\""

if [ "$env" != "local" ]; then
    echo "Caching configuration..."
    # (cd /var/www && php artisan config:cache && php artisan route:cache && php artisan view:cache)
fi

if [ "$role" = "app" ]; then
    php-fpm

elif [ "$role" = "queue" ]; then
    echo "Queue role"
    exit 1

elif [ "$role" = "scheduler" ]; then
    echo "Scheduler role"
    php /var/www/artisan schedule:work

    # while [ true ]
    # do
    #   php /var/www/artisan schedule:run --verbose --no-interaction &
    #   sleep 10
    # done

else
    echo "Could not match the container role \"$role\""
    exit 1
fi
