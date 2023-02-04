FROM php:8.2-fpm-alpine

RUN apk update && apk add oniguruma-dev && apk add libxml2-dev

RUN docker-php-ext-install bcmath ctype mbstring fileinfo pdo pdo_mysql dom pcntl

COPY crontab /etc/crontabs/root

CMD ["crond", "-f"]