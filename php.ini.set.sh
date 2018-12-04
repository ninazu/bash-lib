#!/bin/bash

PHP="5.6.38"
EXTENSION_DIR=$(/opt/php-$PHP/bin/php -r "echo ini_get('extension_dir');")
PHP_INI=/opt/php-$PHP/php.ini

declare -A INISET=(
   ["zend_extension"]="$EXTENSION_DIR/xdebug.so"
   ["short_open_tag"]="On"
   ["always_populate_raw_post_data"]=-1
    #error_reporting = E_ALL
    #display_errors = On
    #display_startup_errors = On
    #track_errors = On
    #mysqlnd.collect_memory_statistics = On
    #date.timezone setting = ''
)

for KEY in "${!INISET[@]}"
do
    if grep -q $KEY $PHP_INI; then 
        SED_VALUE=$(sed 's/\ /\\ /g' <<<"${INISET[$KEY]}")
        SED="s%[;]$KEY = .*%$KEY = $SED_VALUE%"
        echo $SED
        sed -i "$SED" $PHP_INI
    else
        echo "$KEY=${INISET[$KEY]}" >> $PHP_INI
    fi
done
