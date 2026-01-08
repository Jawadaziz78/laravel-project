FROM php:8.2-fpm-alpine

# 1. Install system dependencies required for Laravel extensions
RUN apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    zip \
    libzip-dev \
    unzip \
    icu-dev \
    oniguruma-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip intl mbstring bcmath

# 2. Copy the Composer binary from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# 3. Copy all project files into the container
# This uses your .dockerignore to skip node_modules and local vendor folders
COPY . .

# 4. CRITICAL: Install PHP dependencies inside the container
# This fixes the 500 error caused by missing framework files
RUN composer install --no-interaction --optimize-autoloader --no-dev

# 5. Set correct permissions for Laravel's writeable directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
