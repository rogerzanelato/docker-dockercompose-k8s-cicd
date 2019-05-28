FROM php:7.1-apache

ARG xdebugip

EXPOSE 9000

RUN apt-get update

RUN apt-get install -y libpq-dev \
    libpng-dev \
    zip unzip \
    git \
    libzip-dev \
    freetds-bin \
    freetds-dev \
	freetds-common \ 
    libsybdb5 && \
    ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/ && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-install pdo pdo_pgsql pgsql pdo_dblib && \
    docker-php-ext-configure pdo_dblib --with-libdir=lib/x86_64-linux-gnu && \
    docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install zip && \
    docker-php-ext-install gd 

# soap
RUN apt-get install -y libxml2-dev && \
    docker-php-ext-install soap

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite

# xdebug
RUN apt-get update \
    && pecl install xdebug-2.6.1 \
    && docker-php-ext-enable xdebug 

# imagick
RUN apt-get -y install libmagickwand-dev --no-install-recommends && \
    pecl install imagick && \
    docker-php-ext-enable imagick

# Default XDebug configuration
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-enabled/*.conf
