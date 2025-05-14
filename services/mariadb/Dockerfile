FROM alpine:3.20.6

RUN apk add mariadb mariadb mariadb-client mariadb-common
RUN mkdir /run/mysqld
RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql

COPY mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY init.sql etc/mysql/init.sql

CMD ["mysqld"]
0