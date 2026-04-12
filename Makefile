# Variables
COMPOSE_FILE=docker-compose.yml
COMPOSE_FILE_START=docker-compose-start.yml
CERTBOT_EMAIL=rando.bayor@gmail.com

.PHONY: up down restart status logs shell clean heartbeat

# Starts the local environment and forces a build so your latest code is used
up_start:	
	docker compose -f $(COMPOSE_FILE_START) up --build -d

up:	
	docker compose -f $(COMPOSE_FILE) up --build -d

# Shuts down the local environment
down:
	docker compose -f $(COMPOSE_FILE) down

down_start:	
	docker compose -f $(COMPOSE_FILE_START) down

cert_init_frontend:
	docker run -it --rm --name certbot \
	  -v "$$(pwd)/certbot/conf:/etc/letsencrypt" \
	  -v "$$(pwd)/certbot/www:/var/www/certbot" \
	  certbot/certbot certonly \
	  --webroot -w /var/www/certbot \
	  -d movie-trip.kurangdoa.com \
	  --email $(CERTBOT_EMAIL) \
	  --agree-tos \
	  --no-eff-email

cert_init_langfuse:
	docker run -it --rm --name certbot \
	  -v "$$(pwd)/certbot/conf:/etc/letsencrypt" \
	  -v "$$(pwd)/certbot/www:/var/www/certbot" \
	  certbot/certbot certonly \
	  --webroot -w /var/www/certbot \
	  -d langfuse.kurangdoa.com \
	  --email $(CERTBOT_EMAIL) \
	  --agree-tos \
	  --no-eff-email

cert_init_mlflow:
	docker run -it --rm --name certbot \
	  -v "$$(pwd)/certbot/conf:/etc/letsencrypt" \
	  -v "$$(pwd)/certbot/www:/var/www/certbot" \
	  certbot/certbot certonly \
	  --webroot -w /var/www/certbot \
	  -d mlflow.kurangdoa.com \
	  --email $(CERTBOT_EMAIL) \
	  --agree-tos \
	  --no-eff-email

# Runs all three certbot commands sequentially
cert_init_all: cert_init_frontend cert_langfuse cert_mlflow