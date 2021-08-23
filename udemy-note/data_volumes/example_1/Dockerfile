FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

# VOLUME [ "/app/feedback" ]

CMD ["node", "server.js"]

# nodemon으로 실행할 경우 
# CMD ["npm", "start"]
