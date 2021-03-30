FROM hacklab/php:7.4-apache
MAINTAINER Hacklab <contato@hacklab.com.br>

ARG WP_VERSION=5.7
COPY root/ /

RUN apt-get update 
RUN apt-get -y install libmagickwand-dev --no-install-recommends 
RUN printf "\n" | pecl install imagick 
RUN docker-php-ext-enable imagick 
RUN rm -r /var/lib/apt/lists/*
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap
RUN apt-get -yqq install exiftool
RUN docker-php-ext-configure exif
RUN docker-php-ext-install exif
RUN docker-php-ext-enable exif

RUN a2enmod headers \
    && docker-php-ext-install pdo_mysql sockets \
    && printf "no\n" | pecl install redis \
    && echo 'extension=redis.so' > /usr/local/etc/php/conf.d/pecl-redis.ini \
    && curl -s -o /opt/wp-cli/wp-cli.phar 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar' \
    && wp core download --path=/var/www/html/ --version=$WP_VERSION --locale=pt_BR \
    && { \
        echo "file_uploads = On"; \
        echo "upload_max_filesize = 2048M"; \
        echo "post_max_size = 2048M"; \
        echo "max_file_uploads = 20"; \
    } > /usr/local/etc/php/conf.d/wordpress-uploads.ini \
    && chown -R www-data: /var/www/html/ \
    && mkdir -p /docker-entrypoint-extra \
    && mkdir -p /var/www/html/wp-config.d

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
