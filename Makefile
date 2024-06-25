#!/usr/bin/make

.PHONY : help init start down build rebuild

.DEFAULT_GOAL := help

help:
	@echo "\n \
	*********************\n \
	*** Make commands ***\n \
	*********************\n\n \
	help	- Show this help\n \
	init	- Inialize\n \
	start	- Start container (you can send param ENV=pord/ENV=dev)\n \
	down	- Stop container\n \
	build	- build projects image\n \
	rebuild	- Rebuild project \
	"

init:
	@docker run --rm -v .:/usr/src/app -w /usr/src/app node:18-alpine npm install
