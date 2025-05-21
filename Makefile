SSL_CRT = secrets/selfsigned.crt
SSL_KEY = secrets/selfsigned.key
SECRET_VARS = db_pwd wp_admin_n wp_admin_p wp_admin_e wp_u_pass
SECRET_FILES = $(addsuffix .txt, $(addprefix secrets/, $(SECRET_VARS)))
ENVIRONMENT = srcs/.env

all: $(SSL_CRT) $(SECRET_FILES) $(ENVIRONMENT)
	@echo "WELCOME TO INCEPTION! BEFORE STARTING:"
	@echo "	- CONFIGURE THE .env IN THE srcs DIRECTORY! CHANGE <value> TO THE DESIRED VALUE"
	@echo "	- CONFIGURE THE .txt IN THE secrets DIRECTORY! CHANGE <value> TO THE DESIRED VALUE"
	@echo "AFTER THAT U CAN:"
	@make --no-print-directory help

$(SSL_CRT): $(SSL_KEY)

$(SSL_KEY):
	@mkdir -p secrets
	@openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=C Inc/CN=e.com" -newkey rsa:2048 -keyout $(SSL_KEY) -out $(SSL_CRT)

secrets/%.txt:
	@echo "$$(echo $* | tr a-z A-Z)=<value>" > $@

$(ENVIRONMENT):
	@mkdir -p $(dir $@)
	@printf "#Mariadb related environment variables\n\
	DB_USER=<value>\n\
	DB_NAME=<value>\n\
	\n\
	#Wordpress related environment variables\n\
	DOMAIN_NAME=<value>\n\
	WP_TITLE=<value>\n\
	\n\
	#Wordpress user\n\
	WP_U_NAME=<value>\n\
	WP_U_EMAIL=<value>\n\
	WP_U_ROLE=<value>\n" > $@

help:
	@echo "	- all:		DISPLAYS THE ORIGINAL MESSAJE AND CREATES THE secrets/*.txt and srcs/.env files"
	@echo "	- up:		BUILDS THE 3 CONTAINERS DEATACHED, THE ENTRYPOINT IS HOSTED AT localhos:443"
	@echo "	- debug:	SAME AS UP BUT SHOWS ALL THE DOCKER MESSAJES AND KEEPS RUNNING IN THE TERMINAL"
	@echo "	- info:		GIVES SOME INFO ABOUT THE PROJECT"
	@echo "	- value:	EXPLAINS THE MEANING AND USE OF ALL THE MODIFICABLE VALUES"
	@echo "	- help:		DISPLAIS THE MAKE OPTIONS"
	@echo "	- clean:	ELIMINATES THE CONTAINERS AND THE IMAGENES BUT NOT THE VOLUMENS, secrets and .env"
	@echo "	- fclean:	CALLS make clean AND REMOVES THE VOLUMENS, secrets and .env"
	@echo "	- re:		CALLS make clean AND make up"

up:
	docker compose -f srcs/docker-compose.yml up --build -d

debug:
	docker compose -f srcs/docker-compose.yml up --build

info:
	@echo "INCEPTION:"
	@echo "A Wordpress PAGE WITH A Mariadb DATABASE WORKING WITH Nginx TO ALLOW SECURE TRAFIC TO THE PAGE"
	@echo "EACH ONE OF THESE SERVICES IS DIVIDED INTO INDIVIDUAL DOCKER CONTAINERS"
	@echo "EACH CONTAINER IS GIVEN THE srcs/.env, THE secrets THEY NEED AND CONF. FILES"
	@echo "THE CONTAINERS ARE CONNECTED TO EACHOTHER VIA DOCKER NETWORK"
	@echo " - Nginx:"
	@echo "	THE FRONT-END OF THE PAGE"
	@echo "	IS THE ONLY ENTRYPOINT ALLOW, AT :443"
	@echo "	IS SECURED BY SSL, USING THE .crt AND .key stored in secrets/"
	@echo "	IT CAN ACCES THE VOLUMEN WHERE THE PAGE IS STORED TO RESPOND TO HTML RECUEST"
	@echo "	WHEN A PHP RECUEST IS GIVEN GIVES THE RECUEST TO THE Wordpress CONTAINER VIA :9000"
	
	@echo " - Wordpress:"
	@echo "	THE SERVER OF THE CONTENT IN THE PAGE"
	@echo "	TAKES THE RECUESTS FROM Nginx AND RESPONDS VIA PHP-FPM"
	@echo "	IT CAN ACCES THE VOLUMEN WHERE THE PAGE IS STORED"
	@echo "	UPON ISTALLATION CREATES A DATABASE IN THE Mariadb CONTAINER"
	@echo "	ALSO ADDS A NEW USER TO THE DATABASE"
	@echo "	COMUNICATES WITH THE Mariadb CONTAINER VIA :3306"
	
	@echo " - Mariadb:"
	@echo "	THE DATABASE OF THE PAGE"
	@echo "	IT CAN ACCES THE VOLUMEN WHERE THE DATABASE IS STORED"

	@echo "APART FROM THE CONTAINERS THE MODIFICABLE VALUES ARE STORED IN secrets/ and srcs/.env"
	@echo "FOR MORE INFO ABOUT EACH MODIFICABLE VALUE USE make value"
	@echo " - secrets/:"
	@echo "	UTILICES A DOCKER COMPOSE FUNCIONALITY TO HAVE THE SENSIBLE INFORMATION AS SAFE AS POSIBLE"
	@echo " - srcs/.env:"
	@echo "	IS NOT TREATED AS SENSIBLE INFORMATION, THIS ENVIRONMENT VARIABLES ARE GIVEN TO ALL CONTAINERS"


value:
	@echo "CONFIGURE THE .env IN THE srcs DIRECTORY! CHANGE <value> TO THE DESIRED VALUE"
	@echo "CONFIGURE THE .txt IN THE secrets DIRECTORY! CHANGE <value> TO THE DESIRED VALUE"
	@echo "secrets/*.txt:"
	@echo "	- DB_PWD:	THE Mariadb USER PASSWORD"
	@echo "	- WP_ADMIN_E:	THE Wordpress ADMIN EMAIL"
	@echo "	- WP_ADMIN_N:	THE Wordpress ADMIN NAME"
	@echo "	- WP_ADMIN_P:	THE Wordpress ADMIN PASSWORD"
	@echo "	- WP_U_PASS:	THE Wordpress USER PASSWORD"
	@echo "srcs/.env:"
	@echo "	- DB_USER:	THE Mariadb USER NAME"
	@echo "	- DB_NAME:	THE Mariadb DATABASE NAME"
	@echo "	- WP_U_NAME:	THE Wordpress USER NAME"
	@echo "	- WP_U_EMAIL:	THE Wordpress USER EMAIL"
	@echo "	- WP_U_ROLE:	THE Wordpress USER ROLE"

down: 
	docker-compose -f ./srcs/docker-compose.yml down 
	docker-compose -f srcs/docker-compose.yml down --volumes

clean: down
	docker system prune -af
	docker volume prune -f

fclean: clean
	rm -fr secrets
	rm srcs/.env
	sudo rm -rf /home/$(USER)/data

re: clean up

.PHONY: all help up debug info value
