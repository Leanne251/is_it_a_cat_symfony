# Use official PHP image with Apache and necessary extensions
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set the working directory to where Symfony will be copied
WORKDIR /var/www

# Copy project files into the container
COPY . /var/www

# Set Apache DocumentRoot to Symfony's /public directory
RUN sed -i "s#DocumentRoot /var/www/html#DocumentRoot /var/www/public#g" \
    /etc/apache2/sites-available/000-default.conf

# Install Composer (from official Composer image)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Symfony dependencies (in /var/www)
RUN composer install --no-interaction --prefer-dist

# Create the var directory (excluded from Git)
RUN mkdir -p /var/www/var

# Fix permissions (especially for cache/logs)
RUN chown -R www-data:www-data /var/www/var /var/www/vendor

# Expose Apache HTTP port
EXPOSE 80

# Start Apache in foreground
CMD ["apache2-foreground"]
