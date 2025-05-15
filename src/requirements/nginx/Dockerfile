FROM alpine:3.20.6

RUN apk add nginx
RUN apk add openssl
RUN openssl req -x509 -nodes -days 365 -subj  "/C=CA/ST=QC/O=C Inc/CN=e.com" -newkey rsa:2048 -keyout /etc/nginx/selfsigned.key -out /etc/nginx/selfsigned.crt

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
