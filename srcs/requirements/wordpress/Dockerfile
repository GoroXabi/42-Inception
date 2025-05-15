FROM alpine:3.20.6

RUN apk add openrc php php-phar php-fpm php-mysqli php-mbstring curl

COPY www.conf /etc/php83/php-fpm.d/www.conf
COPY php.ini /etc/php83/
COPY script.sh .

RUN chmod +x script.sh

CMD ["./script.sh"]

