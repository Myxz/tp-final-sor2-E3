.PHONY: help install up down

help:
	@echo " make install - Instala dependencias (Docker, Auditd, Filebeat) y configura el SO."
	@echo " make up - Levanta el stack ELK con Docker Compose."
	@echo " make down - Detiene y elimina los contenedores del stack ELK." 

install:
	sudo bash setup.sh

up:
	docker compose up -d

down:
	docker compose down
