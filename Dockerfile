# add keys to container
FROM composer as dependencies
COPY id_rsa /root/.ssh/id_rsa
COPY known_hosts /root/.ssh/known_hosts
WORKDIR /app/
COPY . ./
RUN composer install

# php-fpm first one
FROM php:fpm-alpine
COPY --from=dependencies /app /var/www/html
RUN docker-php-ext-install pdo_mysql
CMD ["php-fpm"]
EXPOSE 9000

# php-fpm from Bastian
#FROM composer as dependencies
#COPY id_rsa /root/.ssh/id_rsa
#COPY known_hosts /root/.ssh/known_hosts
#WORKDIR /app/
#COPY . ./
#RUN composer install

#FROM php:apache
#LABEL maintainer="test@elanders.com"
#RUN docker-php-ext-install pdo_mysql
#ENV APACHE_DOCUMENT_ROOT /var/www/html/public
#RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
#RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
#COPY --from=dependencies /app /var/www/html
#EXPOSE 80
