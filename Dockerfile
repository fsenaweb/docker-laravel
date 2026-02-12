# Estágio 1: Base - Instalação de dependências do sistema e extensões PHP
FROM php:8.3-fpm as base

# Define o diretório de trabalho
WORKDIR /var/www

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    unzip \
    git \
    curl \
    libzip-dev \
    libonig-dev \
    libicu-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala extensões PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# -----------------------------------------------------------------------------

# Estágio 2: Vendor - Instalação das dependências do Composer
FROM base as vendor

COPY database /var/www/database
COPY composer.json composer.lock /var/www/
RUN composer install --no-interaction --no-plugins --no-scripts --prefer-dist

# -----------------------------------------------------------------------------

# Estágio 3: Frontend - Instalação do Node e compilação de assets
FROM node:16 as frontend

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build

# -----------------------------------------------------------------------------

# Estágio Final: App - Cria a imagem final e limpa
FROM base as app

# Copia as dependências do Composer do estágio 'vendor'
COPY --from=vendor /var/www/vendor /var/www/vendor

# Copia os assets compilados do estágio 'frontend'
COPY --from=frontend /app/public /var/www/public

# Copia o restante do código da aplicação
COPY . /var/www

# Ajusta permissões
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage

# Expõe a porta e inicia o PHP-FPM
EXPOSE 9000
CMD ["php-fpm"]
