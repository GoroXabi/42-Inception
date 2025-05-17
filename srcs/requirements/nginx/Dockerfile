FROM alpine:3.20.6

RUN apk add nginx
RUN apk add openssl

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
