DIRECTORYDATA := /home/${USER}/incept/data
DIRECTORYCOMPOSE := /home/${USER}/incept/srcs/docker-compose.yml
POSTGRESQLVOLUME := $(DIRECTORYDATA)/piscineds
PGADMINVOLUME := $(DIRECTORYDATA)/pgadmindata

NAME := PiscineData

SRCS_DIR = ./srcs

up := $(NAME)

$(NAME):
	@mkdir -p $(DIRECTORYDATA)
	@mkdir -p $(POSTGRESQLVOLUME)
	@mkdir -p $(PGADMINVOLUME)
	@echo "creation volumes directory"
	@cd $(SRCS_DIR) && docker compose up --build -d --force-recreate
	@echo "docker compose up"

down:
	@cd $(SRCS_DIR) && docker compose -f $(DIRECTORYCOMPOSE) down
	@echo "docker compose down"

ps:
	@cd $(SRCS_DIR) && docker compose ps
	@echo "docker compose down"

clean:
	@cd $(SRCS_DIR) && docker compose -f $(DIRECTORYCOMPOSE) down --volumes --remove-orphans
	@echo "docker compose down && clean volumes"

fclean: clean
	@docker system prune -af --volumes
	@docker volume prune -f
	@sudo rm -rf $(POSTGRESQLVOLUME)
	@sudo rm -rf $(PGADMINVOLUME)
	@echo "docker compose down && docker system prune && clean volumes"

re: fclean up

logs:
	@cd $(SRCS_DIR) && docker compose logs -f

.PHONY: up down ps clean fclean re logs
