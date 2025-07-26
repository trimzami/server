FROM php:8.3-fpm-alpine

ENV PHPIZE_DEPS="autoconf gcc g++ make pkgconfig"

# Copy composer from official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Install system dependencies, set timezone, install PHP extensions
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
    && apk del $PHPIZE_DEPS

# Expose port 8080 for external access
EXPOSE 8080

# Default command (use php built-in server)
CMD ["php", "-S", "0.0.0.0:8080", "-t", "public"]
