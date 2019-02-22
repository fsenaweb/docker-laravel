FROM php:7.2-apache

RUN apt-get update

#arquivo necessarios
RUN apt-get install -y \
    curl \
    git \
    supervisor \
    zip \
    unzip

#extesao PHP no docker
RUN apt-get install -y libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

#Optional composer install method
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite

RUN mkdir -p /opt/data/public && \
    rm -rf /var/www/html && \
    ln -s /opt/data/public /var/www/html

WORKDIR /var/www/html