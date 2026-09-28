COMPOSE_FILE = ./srcs/docker-compose.yml
DATA_PATH   = $(HOME)/data

up:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@docker compose -f $(COMPOSE_FILE) up -d --build

down:
	@docker compose -f $(COMPOSE_FILE) down

clean: down
	@docker system prune -af

re: clean up