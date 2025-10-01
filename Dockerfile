FROM php:5-fpm

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list

RUN apt-get update

RUN apt-get install --no-install-recommends -y --allow-unauthenticated \
        libfreetype6-dev \
        libjpeg-dev \
        libjpeg62-turbo-dev \
#        libpng12-dev \
        libpq-dev \
        libmcrypt-dev \
        libicu-dev \
        libxml2-dev \
       #libmagickwand-dev \
        zlib1g-dev \
        g++ \
        git \
        xvfb \
        wkhtmltopdf \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-configure intl \
    && docker-php-ext-install gd iconv intl mcrypt mbstring mysql mysqli pdo_mysql soap zip \
   #&& pecl install imagick \
   #&& docker-php-ext-enable imagick \
    && apt-get purge -y g++ \
    && apt-get autoremove -y


COPY ./php.ini /usr/local/etc/php

COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf
RUN chown -R root:staff /usr/local/etc/php-fpm.d/www.conf
RUN chmod -R 644 /usr/local/etc/php-fpm.d/www.conf

RUN groupadd -g 1000 user \
    && useradd -m -d /home/user -g user -u 1000 user

USER user

#COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf

#USER root
EXPOSE 9000
