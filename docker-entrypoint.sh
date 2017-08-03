#!/bin/bash

keygen() {
    cat /dev/urandom | tr -dc '[:print:]' | tr "\\\\" "-" | tr "'" "-" | head -c64;
}

export AUTH_KEY="${WORDPRESS_AUTH_KEY:-$(keygen)}"
export AUTH_SALT="${WORDPRESS_AUTH_SALT:-$(keygen)}"
export LOGGED_IN_KEY="${WORDPRESS_LOGGED_IN_KEY:-$(keygen)}"
export LOGGED_IN_SALT="${WORDPRESS_LOGGED_IN_SALT:-$(keygen)}"
export NONCE_KEY="${WORDPRESS_NONCE_KEY:-$(keygen)}"
export NONCE_SALT="${WORDPRESS_NONCE_SALT:-$(keygen)}"
export SECURE_AUTH_KEY="${WORDPRESS_SECURE_AUTH_KEY:-$(keygen)}"
export SECURE_AUTH_SALT="${WORDPRESS_SECURE_AUTH_SALT:-$(keygen)}"

export WP_DEBUG="${WORDPRESS_DEBUG:-false}"
export WP_DEBUG_LOG="${WORDPRESS_DEBUG_LOG:-false}"
export WP_DEBUG_DISPLAY="${WORDPRESS_DEBUG_DISPLAY:-false}"


if [ "$OPCACHE" = "true" ];
then
    inifile="/usr/local/etc/php/conf.d/opcache-recommended.ini" ;
    {
        echo 'opcache.memory_consumption=128';
        echo 'opcache.interned_strings_buffer=8';
        echo 'opcache.max_accelerated_files=4000';
        echo 'opcache.revalidate_freq=60';
        echo 'opcache.fast_shutdown=1';
        echo 'opcache.enable_cli=1';
    } > $inifile;
    unset inifile;
fi

if [ "$WP_DEBUG" = "true" ] && [ "$XDEBUG" != "false" ];
then
    inifile="/usr/local/etc/php/conf.d/pecl-xdebug.ini"
    extfile="$(find /usr/local/lib/php/extensions/ -name xdebug.so)";
    remote_port="${XDEBUG_IDEKEY:-9000}";
    idekey="${XDEBUG_IDEKEY:-xdbg}";

    if [ -f "$extfile" ] && [ ! -f "$inifile" ];
    then
        {
            echo "[Xdebug]";
            echo "zend_extension=${extfile}";
            echo "xdebug.idekey=${idekey}";
            echo "xdebug.remote_enable=1";
            echo "xdebug.remote_connect_back=1";
            echo "xdebug.remote_autostart=1";
            echo "xdebug.remote_port=${remote_port}";
        } > $inifile;
    fi
    unset extfile remote_port idekey;
fi

#
# Should I respect the owner of mounted volumes
#
volume=$(mount -l | awk '/var\/www\/html/{ print $3; exit; }')
if [ -n "$volume" ];
then
    uid=$(stat -c %u "$volume")
    gid=$(stat -c %g "$volume")
fi

if [ -n "$uid" ] && [ "$WORDPRESS_DEBUG" = "true" ];
then
    user=$(awk -F: "/:$uid:[0-9]+:/{ print \$1}" /etc/passwd)
    group=$(awk -F: "/:x:$gid:/{ print \$1}" /etc/group)

    if [ -z "$group" ];
    then
        usermod -g "$gid" www-data
    fi

    if [ -z "$user" ];
    then
        usermod -u "$uid" wordpress
    fi
else
    uid=$(awk -F: '/^www-data/{ print $3 }' /etc/passwd)
fi


php=`which php`;
for f in /docker-entrypoint-extra/*; do
    case "$f" in
        *.sh)     echo "$0: running $f"; . "$f" ;;
        *.php)    echo "$0: running $f"; "${php}" < "$f" ;;
        *)        echo "$0: ignoring $f" ;;
    esac
    echo
done

exec "$@"
