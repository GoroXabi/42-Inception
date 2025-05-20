#!/bin/sh

mkdir /etc/mysql
touch /etc/mysql/init.sql
cat <<EOF > /etc/mysql/init.sql
CREATE DATABASE \`$DB_NAME\`;
CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PWD';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

sleep 1

mysql_install_db --user=mysql --ldata=/var/lib/mysql
mysqld