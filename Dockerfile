FROM php:8.2-apache

# Disable conflicting MPM modules, enable prefork only
RUN a2dismod mpm_event mpm_worker 2>/dev/null || true \
    && a2enmod mpm_prefork

# Enable required Apache modules
RUN a2enmod rewrite

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Allow .htaccess override
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Copy all project files
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create cache folder
RUN mkdir -p /var/www/html/cache \
    && chmod 777 /var/www/html/cache

EXPOSE 80

CMD ["apache2-foreground"]
