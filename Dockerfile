ARG VERSION=7
FROM php:${VERSION}-fpm-alpine
RUN apk update \
    && docker-php-ext-install pdo_mysql mysqli \
    && docker-php-ext-enable pdo_mysql mysqli \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /tmp/* \
    && mkdir /var/www/public \
    && chown -R www-data:www-data "/var/www" \
    && rmdir /var/www/html
COPY "php-ini-overrides.ini" "/usr/local/etc/php/php.ini"
USER "www-data"
COPY "index.php" "/var/www/public"
WORKDIR "/var/www/public"