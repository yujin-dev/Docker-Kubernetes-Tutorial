FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

# Dockerfile 내부에서만 사용 가능한 변수 설정
ARG DEFAULT_PORT=80

# default port = 80으로 설정한다.
ENV PORT $DEFAULT_PORT

EXPOSE $PORT

# VOLUME [ "/app/feedback" ]

CMD ["node", "server.js"]

# nodemon으로 실행할 경우 
# CMD ["npm", "start"]
