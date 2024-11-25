FROM node:18

LABEL maintainer="Yannnick Djoumbi <ydjoumbi@gmail.com>"

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 4200

CMD ["npm", "start"]



