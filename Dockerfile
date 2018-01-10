FROM hacklab/php:7-apache
MAINTAINER Hacklab <contato@hacklab.com.br>

RUN a2enmod headers \
    && docker-php-ext-install pdo_mysql sockets \
    && printf "yes" | pecl install memcached \
    && printf "no\n" | pecl install redis \
    && echo 'extension=redis.so' > /usr/local/etc/php/conf.d/pecl-redis.ini \
    && echo 'extension=memcached.so' > /usr/local/etc/php/conf.d/pecl-memcached.ini \
    && curl -s -o wp-cli.phar 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar' \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && wp core download --path=/var/www/html/ --version=4.9.1 --locale=pt_BR --allow-root \
    && { \
        echo "file_uploads = On"; \
        echo "upload_max_filesize = 2048M"; \
        echo "post_max_size = 2048M"; \
        echo "max_file_uploads = 20"; \
    } > /usr/local/etc/php/conf.d/wordpress-uploads.ini

COPY docker-entrypoint.sh /entrypoint.sh
COPY htaccess /var/www/html/.htaccess
COPY wp-config.php /var/www/html/wp-config.php

RUN chown -R www-data: /var/www/html/ \
    && mkdir -p /docker-entrypoint-extra \
    && mkdir -p /var/www/html/wp-config.d \
    && echo "alias wp='/usr/local/bin/wp --allow-root'" >> /root/.bashrc

ENV PAGER /bin/cat

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
