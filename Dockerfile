ARG NGINX_VERSION

FROM nginx:${NGINX_VERSION}-alpine

ENV NGINX_ERROR_LOG=/dev/fd/2 \
    NGINX_ACCESS_LOG=/dev/fd/1 \
    FILE=/etc/ssl/certs/project.crt

COPY templates /etc/nginx/templates/

RUN apk add --update --no-cache openssl \
    && openssl req -x509 -nodes -days 3650 -newkey rsa:1024 \
        -keyout /etc/ssl/certs/project.key \
        -out $FILE \
        -subj "/C=FR/L=Lille/O=App Project/OU=Development/CN=*.$NGINX_HOST" \
    && envsubst \$NGINX_ERROR_LOG,\$NGINX_ACCESS_LOG,\$NGINX_PROJECT,\NGINX_HOST < /etc/nginx/templates/default.conf.template > /etc/nginx/default.conf \
    && rm /etc/nginx/templates/default.conf.template

