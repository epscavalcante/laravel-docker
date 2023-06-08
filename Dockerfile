FROM php:8.1.18-fpm-alpine3.18 as builder

RUN apk add --no-cache shadow openssl bash

RUN docker-php-ext-install pdo\
    && docker-php-ext-install pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

RUN rm -rf /var/www/html

COPY . /var/www

RUN composer install \
    && php artisan optimize:clear
    # \& chmod -R 775 storage

RUN chown -R www-data:www-data /var/www

RUN ln -s public html

RUN usermod -u 1000 www-data

FROM php:8.1.18-fpm-alpine3.18

RUN apk add --no-cache bash

RUN docker-php-ext-install pdo\
    && docker-php-ext-install pdo_mysql

WORKDIR /var/www

RUN rm -rf /var/www/html

COPY --from=builder /var/www .

EXPOSE 9000

CMD [ "php-fpm" ]
