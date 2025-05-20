FROM alpine:3.20.6

RUN apk add mariadb mariadb mariadb-client mariadb-common
RUN mkdir /run/mysqld

COPY mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY script.sh .

RUN chmod +x script.sh

CMD ["./script.sh"]
