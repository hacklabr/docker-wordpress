FROM hacklab/php:7-apache
MAINTAINER Hacklab <contato@hacklab.com.br>

RUN curl -s -o wp-cli.phar 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar' \
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
    && echo "alias wp='/usr/local/bin/wp --allow-root'" >> /root/.bashrc

ENV PAGER /bin/cat

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
