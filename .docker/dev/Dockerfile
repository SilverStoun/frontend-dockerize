FROM node:18-alpine

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY /src/package*.json .
RUN yarn install

COPY /src .