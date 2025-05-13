FROM alpine:3.20.6

RUN apk add php-fpm

COPY www.conf /etc/php83/php-fpm.d/www.conf

CMD ["php-fpm83", "-F"]
