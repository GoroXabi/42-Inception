SSL_CRT = secrets/selfsigned.crt
SSL_KEY = secrets/selfsigned.key
SECRET_VARS = db_pwd wp_admin_n wp_admin_p wp_admin_e wp_u_pass
SECRET_FILES = $(addsuffix .txt, $(addprefix secrets/, $(SECRET_VARS)))
ENVIRONMENT = srcs/.env

all: $(SSL_CRT) $(SECRET_FILES) $(ENVIRONMENT)

$(SSL_CRT): $(SSL_KEY)

$(SSL_KEY):
	mkdir -p secrets
	openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=C Inc/CN=e.com" -newkey rsa:2048 -keyout $(SSL_KEY) -out $(SSL_CRT)

secrets/%.txt:
	echo "$$(echo $* | tr a-z A-Z)=" > $@

ENVIRONMENT = srcs/.env

$(ENVIRONMENT):
	mkdir -p $(dir $@)
	printf "#User\n\
	USER=xortega\n\
	DOMAIN_NAME=xortega.42.fr\n\
	\n\
	#Mariadb related environment variables\n\
	DB_USER=xortega\n\
	DB_NAME=wordpress\n\
	\n\
	#Wordpress related environment variables\n\
	WP_TITLE=Inception\n\
	\n\
	#Wordpress user\n\
	WP_U_NAME=xortega\n\
	WP_U_EMAIL=xortega@42.com\n\
	WP_U_ROLE=author\n" > $@

debug:
	docker compose -f srcs/docker-compose.yml up --build

down: 
	docker-compose -f ./srcs/docker-compose.yml down 
	docker-compose -f srcs/docker-compose.yml down --volumes

clean: down
	docker system prune -af
	docker volume prune -f
	rm -fr secrets
	rm srcs/.env
	sudo rm -rf /home/$(USER)/data

fclean: clean

re: clean all

