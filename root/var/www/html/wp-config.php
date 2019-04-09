<?php
    foreach(glob(dirname(__FILE__) . '/' . 'wp-config.d/*.php') as $config) {
        include($config);
    }

    !defined('DB_USER')          && define('DB_USER',          getenv('WORDPRESS_DB_USER')        ?: 'wordpress');
    !defined('DB_NAME')          && define('DB_NAME',          getenv('WORDPRESS_DB_NAME')        ?: 'wordpress');
    !defined('DB_PASSWORD')      && define('DB_PASSWORD',      getenv('WORDPRESS_DB_PASSWORD')    ?: 'wordpress');
    !defined('DB_HOST')          && define('DB_HOST',          getenv('WORDPRESS_DB_HOST')        ?: 'mariadb');
    !defined('DB_PORT')          && define('DB_PORT',          getenv('WORDPRESS_DB_PORT')        ?: '3306');
    !defined('DB_CHARSET')       && define('DB_CHARSET',       getenv('WORDPRESS_DB_CHARSET')     ?: 'utf8');
    !defined('DB_COLLATE')       && define('DB_COLLATE',       getenv('WORDPRESS_DB_COLLATE')     ?: '');

    !defined('AUTH_KEY')         && define('AUTH_KEY',         getenv('WORDPRESS_AUTH_KEY'));
    !defined('SECURE_AUTH_KEY')  && define('SECURE_AUTH_KEY',  getenv('WORDPRESS_SECURE_AUTH_KEY'));
    !defined('LOGGED_IN_KEY')    && define('LOGGED_IN_KEY',    getenv('WORDPRESS_LOGGED_IN_KEY'));
    !defined('NONCE_KEY')        && define('NONCE_KEY',        getenv('WORDPRESS_NONCE_KEY'));
    !defined('AUTH_SALT')        && define('AUTH_SALT',        getenv('WORDPRESS_AUTH_SALT'));
    !defined('SECURE_AUTH_SALT') && define('SECURE_AUTH_SALT', getenv('WORDPRESS_SECURE_AUTH_SALT'));
    !defined('LOGGED_IN_SALT')   && define('LOGGED_IN_SALT',   getenv('WORDPRESS_LOGGED_IN_SALT'));
    !defined('NONCE_SALT')       && define('NONCE_SALT',       getenv('WORDPRESS_NONCE_SALT'));
    !defined('FS_METHOD')        && define('FS_METHOD',        getenv('WORDPRESS_FS_METHOD')      ?: 'direct');

    !defined('WP_DEBUG')         && define('WP_DEBUG',         getenv('WORDPRESS_DEBUG')         === 'true');
    !defined('WP_DEBUG_LOG')     && define('WP_DEBUG_LOG',     getenv('WORDPRESS_DEBUG_LOG')     === 'true');
    !defined('WP_DEBUG_DISPLAY') && define('WP_DEBUG_DISPLAY', getenv('WORDPRESS_DEBUG_DISPLAY') === 'true');
    
    if(!isset($table_prefix)) {
        $table_prefix = getenv('WORDPRESS_TABLE_PREFIX')   ?: 'wp_';
    }

    if ( !WP_DEBUG_LOG ) {
        ini_set('log_errors', 1);
        ini_set('error_log', 'php://stderr');
    }

    if(getenv('HTTPS') === 'on') {
        $_SERVER['HTTPS'] = 'on';
    }

    if (isset($_SERVER['HTTP_X_FORWARDED_PROTO'])
        && strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false) {
      $_SERVER['HTTPS'] = 'on';
    }

    $proto = 'http://';
    if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on') {
        $proto = 'https://';
    }

    if(!defined('WP_HOME')) {
        if (getenv('WORDPRESS_HOME')) {
            define('WP_HOME', getenv('WORDPRESS_HOME'));
        } else {
            define('WP_HOME', $proto . $_SERVER['SERVER_NAME']);
        }
    }

    if(!defined('WP_SITEURL')) {
        if (getenv('WORDPRESS_SITEURL')) {
            define('WP_SITEURL', getenv('WORDPRESS_SITEURL'));
        } else {
            define('WP_SITEURL', $proto . $_SERVER['SERVER_NAME']);
        }
    }
    unset($proto);

    if (!defined('ABSPATH') ) {
        define('ABSPATH', dirname(__FILE__) . '/');
    }
    require_once(ABSPATH . 'wp-settings.php');
