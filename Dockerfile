FROM php:7.2-fpm

# Copiar el directorio existente a /var/www
COPY . /var/www/html

# Configura el directorio raiz
WORKDIR /var/www/html

# Instalamos dependencias
RUN apt-get update && apt-get install -y \
 build-essential \
 libpng-dev \
 libjpeg62-turbo-dev \
 libfreetype6-dev \
 locales \
 zip \
 jpegoptim optipng pngquant gifsicle \
 vim \
 unzip \
 git \
 curl

# Borramos cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* 

# Instalamos extensiones
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

# Instalar composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# agregar usuario para la aplicación laravel
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# copiar los permisos del directorio de la aplicación
COPY --chown=www:www . /var/www

# cambiar el usuario actual por www
USER www
RUN composer install


# exponer el puerto 9000 e iniciar php-fpm server
EXPOSE 9000
CMD ["php-fpm"]