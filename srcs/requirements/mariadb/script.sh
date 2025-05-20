#!/bin/sh

mysql_install_db --user=mysql --ldata=/var/lib/mysql

mkdir /etc/mysql

cat <<EOF > /etc/mysql/init.sql
CREATE DATABASE \`$DB_NAME\`;
CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PWD';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

mysqld