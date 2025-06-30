# Use official PHP image with Apache and necessary extensions
FROM php:8.2-apache

# Install necessary PHP extensions
RUN docker-php-ext-install pdo && docker-php-ext-install pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy Symfony project files into container
COPY . /var/www/html

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Symfony dependencies
RUN composer install --no-interaction

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html/var /var/www/html/vendor

# Expose port 80
EXPOSE 80
