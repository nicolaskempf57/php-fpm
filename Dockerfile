ARG VERSION=7
FROM php:${VERSION}-fpm-alpine
RUN apk update \
    && apk add --no-cache autoconf gcc g++ imagemagick libtool make \
    && pecl install imagick \
    && docker-php-ext-install pdo_mysql mysqli \
    && docker-php-ext-enable pdo_mysql mysqli imagick \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /tmp/* \
    && mkdir /var/www/public \
    && chown -R www-data:www-data "/var/www" \
    && rmdir /var/www/html \
    && apk del autoconf g++ libtool make
COPY "php-ini-overrides.ini" "/usr/local/etc/php/php.ini"
USER "www-data"
COPY "index.php" "/var/www/public"
WORKDIR "/var/www/public"