# Use official PHP image with Apache and necessary extensions
FROM php:8.2-apache

# Install system dependencies (including git)
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Ensure var directory exists (not in Git)
RUN mkdir -p /var/www/

# Set working directory
WORKDIR /var/www

# Copy Symfony project files into container
COPY . /var/www/html

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Symfony dependencies
# RUN composer install --no-interaction --no-scripts --prefer-dist

RUN composer install --no-scripts --no-autoloader

EXPOSE 80

RUN sed -i 's!/var/www/html!/var/www/html/public!g' \
  /etc/apache2/sites-available/000-default.conf

CMD ["apache2-foreground"]