#!/bin/sh

WP_ADMIN_E=$(cut -d '=' -f2 /run/secrets/wp_admin_e.txt)
WP_ADMIN_N=$(cut -d '=' -f2 /run/secrets/wp_admin_n.txt)
WP_ADMIN_P=$(cut -d '=' -f2 /run/secrets/wp_admin_p.txt)
WP_U_PASS=$(cut -d '=' -f2 /run/secrets/wp_u_pass.txt)
DB_PWD=$(cut -d '=' -f2 /run/secrets/db_pwd.txt)

sleep 3
if ! [ -d /var/www/html/wp-config.php ]; then
echo DOWLOADING WORDPRESS
cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PWD" --dbhost=mariadb --allow-root
./wp-cli.phar core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root
./wp-cli.phar user create  "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root
fi
php-fpm83 -F