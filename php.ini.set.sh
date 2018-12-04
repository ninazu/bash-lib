#!/bin/bash

PHP="5.6.38"
EXTENSION_DIR=$(/opt/php-$PHP/bin/php -r "echo ini_get('extension_dir');")
PHP_INI=/opt/php-$PHP/php.ini

declare -A INISET=(
   ["zend_extension"]="$EXTENSION_DIR/xdebug.so"
   ["short_open_tag"]="On"
   ["always_populate_raw_post_data"]=-1
)

for KEY in "${!INISET[@]}"
do
    if grep -lq "^[;]*[[:space:]]*$KEY[[:space:]]*=[[:space:]]*" $PHP_INI; then 
        SED_VALUE=$(sed 's/\ /\\ /g' <<<"${INISET[$KEY]}")
        SED="s%[;]*[[:space:]]*$KEY[[:space:]]*=[[:space:]]*.*%$KEY = $SED_VALUE%"
        sed -i "$SED" $PHP_INI
    else
        echo "$KEY=${INISET[$KEY]}" >> $PHP_INI
    fi
done
