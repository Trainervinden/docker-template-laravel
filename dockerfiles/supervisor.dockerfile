FROM php:8.2-fpm-alpine

RUN apk update && apk add oniguruma-dev && apk add libxml2-dev

RUN docker-php-ext-install bcmath ctype mbstring fileinfo pdo pdo_mysql dom pcntl

RUN apk update && apk add --no-cache supervisor

RUN mkdir -p "/etc/supervisor/logs"

COPY dockerfiles/configs/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/supervisord.conf"]
