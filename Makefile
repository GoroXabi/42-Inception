
all:
	mkdir secrets
	openssl req -x509 -nodes -days 365 -subj  "/C=CA/ST=QC/O=C Inc/CN=e.com" -newkey rsa:2048 -keyout ./secrets/selfsigned.key -out ./secrets/selfsigned.crt
