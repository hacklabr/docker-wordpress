# WordPress Docker Image

This is an image to help on plugins and themes development, but it
can be used to host a WordPress site as well. There are some tools
and nice librarys included, like *OPCache*, *X-Debug* and *WP-Cli*.


## Development environment

There are a WordPress installed at `/var/www/html`. So if you want
to develop a plugin, you can mount your content mapping your plugin
folder in `/var/www/html/wp-content/plugins`.

Let's suppose you want to test your plugin called *Awesome*, your
`docker-compose.yml` should be like this below.

```
version: '2'

services:
  web:
    image: hacklab/wordpress
    environment:
      - WORDPRESS_DEBUG=true
      - WORDPRESS_DB_USER=the_db_user
      - WORDPRESS_DB_PASSWORD=the_db_pass
      - WORDPRESS_DB_NAME=the_db_name
    ports:
      - "80:80"

  mysql:
    image: mariadb
    environment:
      - MYSQL_USER=the_db_user
      - MYSQL_PASSWORD=the_db_pass
      - MYSQL_DATABASE=the_db_name
      - MYSQL_ROOT_PASSWORD=the_root_pass
      - TERM=xterm
```


### X-Debug

When you set `WORDPRESS_DEBUG=true` in container environment, the X-Debug
configuration will be created automatically, and the container will
receive connections from any host. If you want suppress X-Debug,
set an enviroment variable with false value, like `XDEBUG=false`.

#### Atom users

Tell your Atom about folder mapping by editing `config.cson`. You have
to configure the section called "php-debug". It should look like this:

```
  "php-debug":
    PathMaps: [
      "remotepath;localpath"
      "/var/www/html/;/local/path/to/wordpress/"
    ]
    PhpException:
      CatchableFatalError: false
      Deprecated: false
      FatalError: false
      Notice: false
      ParseError: false
      StrictStandards: false
      UnknownError: false
      Warning: false
      Xdebug: false
    ServerPort: 9000
```

## Modules enabled by default

The modules below are used on most of hacklab WordPress projects and probably may be useful for wide range of projects. While modules can take a lot of memory for each Apache process, the modules below enable users to take advantage of a lot of WordPress Cache plugins, like _W3 Total Cache_.

* apcu
* calendar
* Core
* ctype
* curl
* date
* dom
* fileinfo
* filter
* ftp
* gd
* hash
* iconv
* json
* libxml
* mbstring
* mcrypt
* memcached
* mysqli
* mysqlnd
* openssl
* pcre
* PDO
* pdo_mysql
* pdo_sqlite
* Phar
* posix
* readline
* redis
* Reflection
* session
* SimpleXML
* sockets
* SPL
* sqlite3
* standard
* tokenizer
* xml
* xmlreader
* xmlwriter
* zip
* zlib
