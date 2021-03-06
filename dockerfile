FROM php:7.4.0-fpm-alpine

RUN apk add --no-cache open ssl bash mysql-client

RUN docker-php-ext-install pdo pdo_mysql bcmath

WORKDIR /var/www

RUN rm -rf /var/www/html  

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 9000

ENTRYPOINT ["php-fpm"]
