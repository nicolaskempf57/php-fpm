ARG VERSION=7
FROM php:${VERSION}-fpm-alpine
COPY --chown=www-data:www-data "cron.sh" "/usr/local/bin/cron"
RUN apk update \
    && apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev apk-cron \
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-ext-install pdo_mysql mysqli fileinfo exif opcache \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /tmp/* \
    && mkdir /var/www/public \
    && chown -R www-data:www-data "/var/www" \
    && rmdir /var/www/html \
    && chmod +x /usr/local/bin/cron \
    && sed -i "s|pm\.max_children.*|pm.max_children = 15|g" /usr/local/etc/php-fpm.d/www.conf
COPY "php-ini-overrides.ini" "/usr/local/etc/php/php.ini"
USER "www-data"
COPY "index.php" "/var/www/public"
WORKDIR "/var/www/public"