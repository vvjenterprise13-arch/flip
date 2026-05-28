FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Apache + PHP
RUN apt-get update && apt-get install -y \
    apache2 \
    php8.1 \
    php8.1-mysqli \
    php8.1-pdo \
    php8.1-pdo-mysql \
    libapache2-mod-php8.1 \
    && apt-get clean

# Enable rewrite
RUN a2enmod rewrite php8.1

# Allow .htaccess
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Copy files
RUN rm -rf /var/www/html/*
COPY . /var/www/html/

# Permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && mkdir -p /var/www/html/cache \
    && chmod 777 /var/www/html/cache

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
