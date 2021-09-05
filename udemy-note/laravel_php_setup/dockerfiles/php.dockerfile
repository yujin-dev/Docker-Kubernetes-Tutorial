FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

COPY src .

RUN docker-php-ext-install pdo pdo_mysql
# access denied 해결 :/var/www/html 권한 부여
RUN chown -R www-data:www-data /var/www/html