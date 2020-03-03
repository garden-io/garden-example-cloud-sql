FROM node:9-alpine

ENV PORT=8080
EXPOSE ${PORT}
WORKDIR /app

RUN apk --update add postgresql-client
RUN npm install -g nodemon

COPY package.json /app
RUN npm install

COPY . /app

CMD ["npm", "start"]
