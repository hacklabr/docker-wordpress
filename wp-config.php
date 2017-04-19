<?php
    define('DB_USER',          getenv('WORDPRESS_DB_USER')        ?: 'wordpress');
    define('DB_NAME',          getenv('WORDPRESS_DB_NAME')        ?: 'wordpress');
    define('DB_PASSWORD',      getenv('WORDPRESS_DB_PASSWORD')    ?: 'wordpress');
    define('DB_HOST',          getenv('WORDPRESS_DB_HOST')        ?: 'mysql');
    define('DB_CHARSET',       getenv('WORDPRESS_DB_CHARSET')     ?: 'utf8');
    define('DB_COLLATE',       getenv('WORDPRESS_DB_COLLATE')     ?: '');

    define('AUTH_KEY',         getenv('WORDPRESS_AUTH_KEY'));
    define('SECURE_AUTH_KEY',  getenv('WORDPRESS_SECURE_AUTH_KEY'));
    define('LOGGED_IN_KEY',    getenv('WORDPRESS_LOGGED_IN_KEY'));
    define('NONCE_KEY',        getenv('WORDPRESS_NONCE_KEY'));
    define('AUTH_SALT',        getenv('WORDPRESS_AUTH_SALT'));
    define('SECURE_AUTH_SALT', getenv('WORDPRESS_SECURE_AUTH_SALT'));
    define('LOGGED_IN_SALT',   getenv('WORDPRESS_LOGGED_IN_SALT'));
    define('NONCE_SALT',       getenv('WORDPRESS_NONCE_SALT'));

    define('FS_METHOD',        getenv('WORDPRESS_FS_METHOD')      ?: 'direct');

    $table_prefix  =           getenv('WORDPRESS_TABLE_PREFIX')   ?: 'wp_';
    define('WP_DEBUG',         getenv('WORDPRESS_DEBUG')         === 'true');
    define('WP_DEBUG_LOG',     getenv('WORDPRESS_DEBUG_LOG')     === 'true');
    define('WP_DEBUG_DISPLAY', getenv('WORDPRESS_DEBUG_DISPLAY') === 'true');

    if ( !WP_DEBUG_LOG ) {
        ini_set('log_errors', 1);
        ini_set('error_log', 'php://stderr');
    }

    if ( !defined('ABSPATH') ) {
        define('ABSPATH', dirname(__FILE__) . '/');
    }

    if(getenv('HTTPS') === 'on') {
        $_SERVER['HTTPS'] = 'on';
    }

    if (isset($_SERVER['HTTP_X_FORWARDED_PROTO'])
        && strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false) {
      $_SERVER['HTTPS'] = 'on';
    }

    foreach(glob(ABSPATH . 'wp-config.d/*.php') as $config) {
        include($config);
    }

    require_once(ABSPATH . 'wp-settings.php');

