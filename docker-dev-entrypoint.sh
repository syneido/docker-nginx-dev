#!/bin/sh

if [ -f "$FILE" ]
 then
    echo "certificate already generated"
 else
    echo "generating certificate"
    openssl req -x509 -nodes -days 3650 -newkey rsa:1024 \
        -keyout /etc/ssl/certs/project.key \
        -out /etc/ssl/certs/project.crt \
        -subj "/C=EN/L=London/O=App Project/OU=Development/CN=*.$NGINX_HOST"
fi

exec /docker-entrypoint.sh "$@"

