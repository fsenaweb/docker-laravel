FROM php:7.2-apache

RUN apt-get update -y

#arquivo necessarios
RUN apt-get install -y \
    curl git supervisor \
    zip unzip apt-utils \
    zlib1g-dev libicu-dev wget gnupg g++ openssh-client libpng-dev

#instalação do node e yarn
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update \
  && apt-get install -y nodejs \
  && apt-get install -y yarn

RUN npm install vue vue-cli -g

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
