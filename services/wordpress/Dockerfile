FROM alpine:3.20.6

RUN apk add php-fpm
#RUN apk add curl
#RUN apk add php-mysqli

COPY www.conf /etc/php83/php-fpm.d/www.conf

CMD ["php-fpm83", "-F"]
