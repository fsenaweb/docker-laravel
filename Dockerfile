FROM php:7.4-fpm

RUN apt-get update -y

#essential files
RUN apt-get install -y \
    build-essential \
    libpng-dev \
    libonig-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales libzip-dev \
    zip git supervisor \
    jpegoptim optipng pngquant gifsicle \
    nano apt-utils iputils-ping \
    unzip zlib1g-dev libicu-dev wget \
    gnupg g++ openssh-client libpng-dev \
    git curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Node.js instalation (optional)
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update \
  && apt-get install -y nodejs \
  && apt-get install -y yarn

# Vue.js CLI instalation (optional)
RUN yarn global add @vue/cli

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-install gd
RUN docker-php-ext-configure gd

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

#Optional composer install method
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
