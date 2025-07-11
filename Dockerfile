# FROM docker/whalesay:latest
# LABEL Name=simanja Version=0.0.1
# RUN apt-get -y update && apt-get install -y fortunes
# CMD ["sh", "-c", "/usr/games/fortune -a | cowsay"]

# FROM php:8.2-fpm-alpine AS simanja

# # Install system dependencies
# RUN apk update && apk add --no-cache \
#     icu-dev \
#     mariadb-dev \
#     unzip \
#     zip \
#     zlib-dev \
#     libpng-dev \
#     libjpeg-turbo-dev \
#     freetype-dev \
#     oniguruma-dev \
#     bash \
#     libxml2-dev \
#     autoconf \
#     g++ \
#     make \
#     libzip-dev

# # Install PHP extensions
# RUN docker-php-ext-install \
#     intl \
#     pdo_mysql \
#     zip \
#     gd \
#     opcache

# # Configure gd with jpeg/png/freetype
# RUN docker-php-ext-configure gd --with-jpeg --with-freetype

# # Install Composer
# COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# # Set working directory
# WORKDIR /var/www/html

# # Copy project files
# COPY . .

# # Give proper permissions
# RUN chown -R www-data:www-data /var/www/html

# # Expose port
# EXPOSE 9000

# CMD ["php-fpm"]

FROM php:8.2-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    zip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libsodium-dev \
    libpq-dev \
    default-mysql-client \
    default-libmysqlclient-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_pgsql pdo_mysql mbstring exif pcntl bcmath gd zip sodium

# Get Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash && \
    apt-get update && apt-get install -y nodejs

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Expose port used by 'php artisan serve'
EXPOSE 8000

# Install PHP and JS dependencies
# RUN composer install
# RUN npm install

# Run Laravel migrations and start server
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000
