
#all:
#	mkdir -p /home/$(USER)/data/wordpress /home/$(USER)/data/mariadb
#	docker compose -f srcs/docker-compose.yml up --build -d

down: 
	docker-compose -f ./srcs/docker-compose.yml down 
	docker-compose -f srcs/docker-compose.yml down --volumes

clean: down
	docker system prune -af
	docker volume prune -f
	sudo rm -rf /home/$(USER)/data

fclean: clean

re: clean all


all:
	mkdir secrets
	openssl req -x509 -nodes -days 365 -subj  "/C=CA/ST=QC/O=C Inc/CN=e.com" -newkey rsa:2048 -keyout ./secrets/selfsigned.key -out ./secrets/selfsigned.crt
