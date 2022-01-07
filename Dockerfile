FROM php:8.0
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install unzip utility and libs needed by zip PHP extension
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip \
    git

RUN docker-php-ext-install zip

COPY github_key .
RUN eval $(ssh-agent) && \
    ssh-add github_key && \
    ssh-keyscan -H github.com >> /etc/ssh/ssh_known_hosts && \
    git clone git@github.com:Kuharenko/laravel-docker.git /usr/src/laravel

WORKDIR /usr/src/laravel

RUN composer install
RUN composer dump-autoload

CMD php artisan serve --host=0.0.0.0 --port=8000
EXPOSE 8000
