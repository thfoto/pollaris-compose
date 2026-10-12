FROM php:8.4-fpm

ENV COMPOSER_HOME=/tmp/composer

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      git \
      libicu-dev \
      libpq-dev \
      libzip-dev \
      locales \
      unzip \
 && docker-php-ext-configure intl \
 && docker-php-ext-install -j"$(nproc)" \
      intl \
      opcache \
      pcntl \
      pdo \
      pdo_pgsql \
      zip \
 && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

RUN printf '%s\n' \
    'date.timezone=Europe/Berlin' \
    'opcache.enable=1' \
    'opcache.enable_cli=1' \
    'opcache.validate_timestamps=1' \
    > /usr/local/etc/php/conf.d/pollaris-production.ini

WORKDIR /var/html/pollaris

CMD ["php-fpm"]
