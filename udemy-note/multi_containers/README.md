# Multi Containers Applications
example 기준으로 3가지 part로 나뉘어 각각 dockerize한다.
- Database : MongoDB
- Backend : NodeJS REST API
- Frontend : React SPA

## 각각을 dockerize하여 연결

### Dockerize MongoDB
`backend` 내부에서 mongodb를 접속하는데 로컬로 접속하기 위해 port를 개방한다.  
```console
$ docker run --name mongodb --rm -d -p 27017:27017 mongo
```

### Dockerize NodeApp
`app.js`에서 mongodb 주소를 로컬로 접속하여 사용할 수 있도록 `  'mongodb://host.docker.internal:27017/course-goals'`로 명시한다.
```console
$ docker run --name goals-backend --rm -d -p 80:80 goals-node
```

### Dockerize React SPA
로컬에서 react web을 접속할 수 있도록 port를 개방한다.
```console
$ docker run --name goals-frontend --rm -d -p 3000:3000 -it goals-react
```

## network를 이용
```console
$ docker network create goals-net
```