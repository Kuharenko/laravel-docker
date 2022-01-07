FROM php:8.0
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
COPY . /usr/src/laravel
WORKDIR /usr/src/laravel

# Install unzip utility and libs needed by zip PHP extension
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip
RUN docker-php-ext-install zip

RUN composer install
RUN composer dump-autoload

CMD php artisan serve --host=0.0.0.0 --port=8000
EXPOSE 8000
