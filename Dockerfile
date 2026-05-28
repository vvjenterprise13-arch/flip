FROM php:8.2-apache

# Apache modules enable
RUN a2enmod rewrite

# PHP extensions install
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Apache config - allow .htaccess
RUN echo '<Directory /var/www/html>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/allow-override.conf \
    && a2enconf allow-override

# PHP files copy
COPY . /var/www/html/

# Permissions fix
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Cache folder create
RUN mkdir -p /var/www/html/cache \
    && chown www-data:www-data /var/www/html/cache \
    && chmod 777 /var/www/html/cache

EXPOSE 80
