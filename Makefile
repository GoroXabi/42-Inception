SSL_CRT = secrets/selfsigned.crt
SSL_KEY = secrets/selfsigned.key
DUMMIES = DB_PWD WP_ADMIN_N WP_ADMIN_P WP_ADMIN_E WP_U_PASS

all: $(SSL_CRT) $(DUMMIES)

$(SSL_CRT): $(SSL_KEY)

$(SSL_KEY):
	mkdir -p secrets
	openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=C Inc/CN=e.com" -newkey rsa:2048 -keyout ./secrets/selfsigned.key -out ./secrets/selfsigned.crt

$(DUMMIES):
	echo "$(@F)=" > $(addsuffix .txt, $(addprefix secrets/, $(@)))

credentials:
	openssl req -x509 -nodes -days 365 -subj  "/C=CA/ST=QC/O=C Inc/CN=e.com" -newkey rsa:2048 -keyout ./secrets/selfsigned.key -out ./secrets/selfsigned.crt
	docker compose -f srcs/docker-compose.yml up --build -d

debug:
	mkdir secrets
	openssl req -x509 -nodes -days 365 -subj  "/C=CA/ST=QC/O=C Inc/CN=e.com" -newkey rsa:2048 -keyout ./secrets/selfsigned.key -out ./secrets/selfsigned.crt
	docker compose -f srcs/docker-compose.yml up --build


down: 
	docker-compose -f ./srcs/docker-compose.yml down 
	docker-compose -f srcs/docker-compose.yml down --volumes

clean: down
	docker system prune -af
	docker volume prune -f
	rm -fr secrets
	sudo rm -rf /home/$(USER)/data

fclean: clean

re: clean all

