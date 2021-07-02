ARG NGINX_VERSION

FROM nginx:${NGINX_VERSION}-alpine

ENV NGINX_ERROR_LOG=/dev/fd/2 \
    NGINX_ACCESS_LOG=/dev/fd/1 \
    FILE=/etc/ssl/certs/project.crt \
    FPM_ENTRYPOINT=app \
    NGINX_ROOT_DIR=web

COPY docker-dev-entrypoint.sh /
COPY templates /etc/nginx/templates/

RUN apk add --update --no-cache openssl \
    && envsubst \$NGINX_ERROR_LOG,\$NGINX_ACCESS_LOG < /etc/nginx/templates/nginx.conf.template > /etc/nginx/nginx.conf \
    && rm /etc/nginx/templates/nginx.conf.template \
    && rm /etc/nginx/conf.d/default.conf

ENTRYPOINT ["/docker-dev-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
