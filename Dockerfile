FROM php:8.3-fpm-alpine

ENV PHPIZE_DEPS="autoconf gcc g++ make pkgconfig"

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

RUN set -ex && apk add --no-cache \
    git \
    bash \
    tzdata \
    libzip-dev \
    libxml2-dev \
    mariadb-connector-c-dev \
    $PHPIZE_DEPS \
    && cp /usr/share/zoneinfo/Asia/Dubai /etc/localtime \
    && echo "Asia/Dubai" > /etc/timezone \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        mysqli \
        zip \
        pcntl \
        bcmath \
    && echo "extension=mysqli.so" > /usr/local/etc/php/conf.d/mysqli.ini \
    && apk del $PHPIZE_DEPS