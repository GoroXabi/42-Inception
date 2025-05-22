# --- # Colors # --- #
RESET = \033[0m
WHITE_BOLD = \033[1;39m
BLACK_BOLD = \033[1;30m
RED_BOLD = \033[1;31m
GREEN_BOLD = \033[1;32m
YELLOW_BOLD = \033[1;33m
BLUE_BOLD = \033[1;34m
PINK_BOLD = \033[1;35m
CYAN_BOLD = \033[1;36m

WHITE = \033[0;39m
BLACK = \033[0;30m
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
PINK = \033[0;35m
CYAN = \033[0;36m
# ------------------ #

SSL_CRT = secrets/selfsigned.crt
SSL_KEY = secrets/selfsigned.key
SECRET_VARS = db_pwd wp_admin_n wp_admin_p wp_admin_e wp_user_p
SECRET_FILES = $(addsuffix .txt, $(addprefix secrets/, $(SECRET_VARS)))
ENVIRONMENT = srcs/.env

all: $(SSL_CRT) $(SECRET_FILES) $(ENVIRONMENT)
	@printf "WELCOME TO $(YELLOW)INCEPTION$(RESET)! BEFORE STARTING:\n"
	@printf "	- CONFIGURE THE $(CYAN).env$(RESET) IN THE $(CYAN)srcs$(RESET) DIRECTORY! CHANGE <value> TO THE DESIRED VALUE\n"
	@printf "	- CONFIGURE THE $(RED).txt$(RESET) IN THE $(RED)secrets$(RESET) DIRECTORY! CHANGE <value> TO THE DESIRED VALUE\n"
	@printf "AFTER THAT U CAN:\n"
	@make --no-print-directory help

$(SSL_CRT): $(SSL_KEY)

$(SSL_KEY):
	@mkdir -p secrets
	@openssl req -quiet -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=C Inc/CN=e.com" -newkey rsa:2048 -keyout $(SSL_KEY) -out $(SSL_CRT)

secrets/%.txt:
	@printf "$$(printf $* | tr a-z A-Z)=<value>" > $@

$(ENVIRONMENT):
	@mkdir -p $(dir $@)
	@printf "#Mariadb related environment variables\n\
	DB_USER=<value>\n\
	DB_NAME=<value>\n\
	\n\
	#Waordpress related environment variables\n\
	DOMAIN_NAME=<value>\n\
	WP_TITLE=<value>\n\
	\n\
	#Waordpress user\n\
	WP_USER_N=<value>\n\
	WP_USER_E=<value>\n\
	WP_USER_R=<value>\n" > $@

up:
	docker compose -f srcs/docker-compose.yml up --build -d

debug:
	docker compose -f srcs/docker-compose.yml up --build

down: 
	docker compose -f srcs/docker-compose.yml down

info:
	@printf "$(YELLOW)INCEPTION$(RESET):\n"
	@printf "A $(BLUE)Wordpress$(RESET) PAGE WITH A $(PINK)Mariadb$(RESET) DATABASE WORKING WITH $(GREEN)Nginx$(RESET) TO ALLOW SECURE TRAFIC\n"
	@printf "EACH ONE OF THESE SERVICES IS DIVIDED INTO INDIVIDUAL DOCKER CONTAINERS\n"
	@printf "EACH CONTAINER IS GIVEN THE $(CYAN)srcs/.env$(RESET), THE $(RED)secrets$(RESET) THEY NEED AND CONF FILES\n"
	@printf "THE CONTAINERS ARE CONNECTED TO EACHOTHER VIA DOCKER NETWORK\n"

	@printf " - $(GREEN)Nginx$(RESET):\n"
	@printf "	THE FRONT-END OF THE PAGE\n"
	@printf "	IS THE ONLY ENTRYPOINT ALLOW, AT localhost:443\n"
	@printf "	IS SECURED BY SSL, USING THE $(RED).crt$(RESET) AND $(RED).key$(RESET) stored in $(RED)secrets/$(RESET)\n"
	@printf "	IT CAN ACCES THE $(WHITE_BOLD)Volumen$(RESET) WHERE THE PAGE IS STORED TO RESPOND TO HTML RECUEST\n"
	@printf "	WHEN A PHP RECUEST IS GIVEN GIVES THE RECUEST TO THE $(BLUE)Wordpress$(RESET) CONTAINER VIA :9000\n"
	
	@printf " - $(BLUE)Wordpress$(RESET):\n"
	@printf "	THE SERVER OF THE PHP CONTENT IN THE PAGE\n"
	@printf "	TAKES THE RECUESTS FROM $(GREEN)Nginx$(RESET) AND RESPONDS VIA FAST_CGI\n"
	@printf "	IT CAN ACCES THE $(WHITE_BOLD)Volumen$(RESET) WHERE THE PAGE IS STORED\n"
	@printf "	UPON ISTALLATION CREATES A DATABASE IN THE $(PINK)Mariadb$(RESET) CONTAINER\n"
	@printf "	ALSO ADDS A NEW USER TO THE DATABASE\n"
	@printf "	COMUNICATES WITH THE $(PINK)Mariadb$(RESET) CONTAINER VIA :3306\n"
	
	@printf " - $(PINK)Mariadb$(RESET):\n"
	@printf "	THE DATABASE OF THE PAGE\n"
	@printf "	IT CAN ACCES THE $(WHITE_BOLD)Volumen$(RESET) WHERE THE DATABASE IS STORED"

	@printf "APART FROM THE CONTAINERS THE MODIFICABLE VALUES ARE STORED IN $(RED)secrets/$(RESET) and $(CYAN)srcs/.env$(RESET)\n"
	@printf "FOR MORE INFO ABOUT EACH MODIFICABLE VALUE USE make value\n"
	@printf " - $(RED)secrets/$(RESET):\n"
	@printf "	UTILICES A DOCKER COMPOSE FUNCIONALITY TO HAVE THE SENSIBLE INFORMATION AS SAFE AS POSIBLE\n"
	@printf " - $(CYAN)srcs/.env$(RESET):\n"
	@printf "	IS NOT TREATED AS SENSIBLE INFORMATION, THIS ENVIRONMENT VARIABLES ARE GIVEN TO ALL CONTAINERS\n"

value:
	@printf "CONFIGURE THE $(CYAN).env$(RESET) IN THE $(CYAN)srcs$(RESET) DIRECTORY! CHANGE <value> TO THE DESIRED VALUE\n"
	@printf "CONFIGURE THE $(RED).txt$(RESET) IN THE $(RED)secrets$(RESET) DIRECTORY! CHANGE <value> TO THE DESIRED VALUE\n"
	@printf "$(RED)secrets/*.txt$(RESET):\n"
	@printf "	- DB_PWD:	THE $(PINK)Mariadb$(RESET) USER PASSWORD\n"
	@printf "	- WP_ADMIN_E:	THE $(BLUE)Wordpress$(RESET) ADMIN EMAIL\n"
	@printf "	- WP_ADMIN_N:	THE $(BLUE)Wordpress$(RESET) ADMIN NAME\n"
	@printf "	- WP_ADMIN_P:	THE $(BLUE)Wordpress$(RESET) ADMIN PASSWORD\n"
	@printf "	- WP_USER_P:	THE $(BLUE)Wordpress$(RESET) USER PASSWORD\n"
	@printf "$(CYAN)srcs/.env$(RESET):\n"
	@printf "	- DB_USER:	THE $(PINK)Mariadb$(RESET) USER NAME\n"
	@printf "	- DB_NAME:	THE $(PINK)Mariadb$(RESET) DATABASE NAME\n"
	@printf "	- DOMAIN_N:	THE PAGE DOMAIN NAME\n"
	@printf "	- WP_TITLE:	THE $(BLUE)Wordpress$(RESET) TITLE\n"
	@printf "	- WP_USER_N:	THE $(BLUE)Wordpress$(RESET) USER NAME\n"
	@printf "	- WP_USER_E:	THE $(BLUE)Wordpress$(RESET) USER EMAIL\n"
	@printf "	- WP_USER_R:	THE $(BLUE)Wordpress$(RESET) USER ROLE\n"

help:
	@printf "	- all:		DISPLAYS THE ORIGINAL MESSAJE AND CREATES THE $(RED)secrets/*.txt$(RESET) and $(CYAN)srcs/.env$(RESET) files\n"
	@printf "	- up:		BUILDS THE 3 CONTAINERS DEATACHED, THE ENTRYPOINT IS HOSTED AT localhost:443\n"
	@printf "	- debug:	SAME AS UP BUT SHOWS ALL THE DOCKER MESSAJES AND KEEPS RUNNING IN THE TERMINAL\n"
	@printf "	- down:		STOPS THE CONTAINERS\n"
	@printf "	- info:		GIVES SOME INFO ABOUT THE PROJECT\n"
	@printf "	- value:	EXPLAINS THE MEANING AND USE OF ALL THE MODIFICABLE VALUES\n"
	@printf "	- help:		DISPLAIS THE MAKE OPTIONS\n"
	@printf "	- acces:	TRIES TO ENTER THE CONTAINER STORED IN THE $$ CONTAINER VAR\n"
	@printf "	- clean:	ELIMINATES THE CONTAINERS AND THE IMAGENES BUT NOT THE $(WHITE_BOLD)Volumens$(RESET), $(RED)secrets$(RESET) and $(CYAN).env$(RESET)\n"
	@printf "	- vlean:	ELIMINATE THE $(WHITE_BOLD)Volumens$(RESET)\n"
	@printf "	- fclean:	CALLS make clean AND REMOVES THE $(WHITE_BOLD)Volumens$(RESET), $(RED)secrets$(RESET) and $(CYAN).env$(RESET)\n"
	@printf "	- re:		CALLS make clean AND make up\n"

access:
	@docker exec -ti $(CONTAINER) sh

clean: down
	docker system prune -af
	docker volume prune -f

vclean:
	sudo rm -rf /home/$(USER)/data

fclean: clean
	rm -fr secrets
	rm srcs/.env
	sudo rm -rf /home/$(USER)/data

re: clean up

.PHONY: all help up debug info value
