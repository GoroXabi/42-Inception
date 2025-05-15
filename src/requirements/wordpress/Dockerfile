FROM alpine:3.20.6

#RUN apk add php-fpm
RUN apk add php php-fpm curl php-mysqli php-phar php

COPY www.conf /etc/php83/php-fpm.d/www.conf
COPY php.ini /etc/php83/
COPY script.sh .

RUN chmod +x script.sh

CMD ["php-fpm83", "-F"]
