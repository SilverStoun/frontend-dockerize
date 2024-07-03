#!/usr/bin/make

include .env

DOCKER_CONTAINER_NAME ?= frontend-container
DOCKER_IMAGE_NAME ?= frontend-image
DOCKER_IMAGE_VERSION ?= 1.0

NODE_VERSION ?= 20

.PHONY : help create install run down

.DEFAULT_GOAL := help

help:
	@echo "\n \
	*********************\n \
	*** Make commands ***\n \
	*********************\n\n \
	help		- Show this help\n \
	create		- Create project, required arg TYPE (possible types: vue, react, angular)\n \
	install	- Run npm install command\n \
	run		- Run project (required param ENV)\n \
	down		- Stop project\n\n \
	Possible args:\n \
		1. TYPE:\n \
			* react\n \
			* vue\n \
			* angular\n \
		2. ENV:\n \
			* production\n \
			* dev\n\n \
	Example:\n \
		make create TYPE=react\n \
	"

create:
ifneq ($(or $(PROJECT_TYPE),$(wildcard ./src/)),)
	@echo "Project already initialized!"; exit 1
endif

ifeq ($(TYPE), vue)
	@echo Create vue project
	@docker run --rm -v .:/usr/src/app -w /usr/src/app node:$(NODE_VERSION)-alpine npx @vue/cli create --default src

	@echo PROJECT_TYPE=vue >> .env
else ifeq ($(TYPE), react)
	@echo Create react project
	@docker run --rm -v .:/usr/src/app -w /usr/src/app node:$(NODE_VERSION)-alpine npx create-react-app src

	@echo PROJECT_TYPE=react >> .env
else ifeq ($(TYPE), angular)
	@echo Create angular project
	@docker run --rm -v .:/usr/src/app -w /usr/src/app node:$(NODE_VERSION)-alpine npx @angular/cli new src

	@echo PROJECT_TYPE=angular >> .env
else
	@echo Undefined project type
endif

install:
	@docker run --rm -v ./src:/usr/src/app -w /usr/src/app node:$(NODE_VERSION)-alpine npm install

run:
ifndef ENV
	$(error ENV is undefined)
endif
	@docker-compose --profile $(ENV) up --build -d
	@echo Projects $(ENV) running

down:
	@docker-compose --profile $(ENV) down

# start: build
# 	@docker-compose --profile $(ENV) up --build -d

# build:
# 	@docker-compose build --no-cache $(ENV)
