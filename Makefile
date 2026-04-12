# Variables
COMPOSE_FILE=docker-compose.yaml
COMPOSE_FILE_START=docker-compose-start.yaml

.PHONY: up down restart status logs shell clean heartbeat

# Starts the local environment and forces a build so your latest code is used
up_start:	
	docker compose -f $(COMPOSE_FILE_START) up --build -d

up:	
	docker compose -f $(COMPOSE_FILE) up --build -d

# Shuts down the local environment
down:
	docker compose -f $(COMPOSE_FILE) down