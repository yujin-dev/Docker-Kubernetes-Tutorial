# FROM : base image
FROM node
# 실행하려는 action의 위치
WORKDIR /app
# COPY {dockerfile 대상 폴더} {복사할 위치} 
# container에서 /app에 현재 위치의 폴더 내용이 복사된다.
COPY . /app

RUN npm install
# container는 격리된 환경이기에 외부(로컬)에서 접속하려면 port를 따로 열어줘야 한다.
EXPOSE 80
# RUN node server.js는 이미지 빌드시에 필요한 부분이 아님
# CMD : container 시작시 실행됨
CMD ["node", "server.js"]