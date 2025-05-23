#!/bin/sh

DB_PWD=$(cut -d '=' -f2 /run/secrets/db_pwd.txt)

mysql_install_db --user=mysql --ldata=/var/lib/mysql

mkdir /etc/mysql

cat <<EOF > /etc/mysql/init.sql
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE OR REPLACE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PWD';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

mysqld