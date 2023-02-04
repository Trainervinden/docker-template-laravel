FROM php:8.2-fpm-alpine

RUN apk update && apk add oniguruma-dev && apk add libxml2-dev

ARG UID

ARG GID

ARG WEBROOT=/var/www/html

ENV UID=${UID}
ENV GID=${GID}

RUN mkdir -p $WEBROOT

WORKDIR $WEBROOT

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup -g ${GID} --system laravel
RUN adduser -G laravel --system -D -s /bin/sh -u ${UID} laravel

RUN sed -i "s/user = www-data/user = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

RUN docker-php-ext-install bcmath ctype mbstring fileinfo pdo pdo_mysql dom pcntl

USER laravel

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
