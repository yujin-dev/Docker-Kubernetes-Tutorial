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
```console
$ docker run --name mongodb --rm -d --network goals-net mongo
```
mongodb 주소를 `mongodb://mongodb:27017/course-goals`로 변경하여 backend image를 빌드한 후 실행한다.
react SPA와 소통하기 위해서 port 80을 개방한다.
```console
$ docker run --name goals-backend --rm -d -p 80:80 --network goals-net  goals-node
```
react SPA의 코드는 컨테이너에서 실행되는 것이 아닌 브라우저에서 실행된다. `network`로 연결하면 컨테이너에서 접속하기에 오류가 발생하니 port를 개방하여 로컬로 접속한다.
```console
$ docker run --name goals-frontend --rm -p 3000:3000 -it goals-react
```

## Adding Data Persistence
```console
$ docker run --name mongodb -v data:/data/db --rm -d --network goals-net mongo
```
- `/app/node_modules`는 로컬에 `npm`이 설치되어 있다면 컨테이너와 충돌날 수 있기 때문에 컨테이너 내부에선 자체 `node_modules`를 사용하도록 한다. - named volumes로 로컬에 `logs`를 저장한다. bind mounts 폴더가 volumes보다 우선이기에 기존에 logs 폴더가 있더라도 overwrite되지 않는다. 
```console
$ docker run --name goals-backend  -v /home/leeyujin/yujin-dev/Docker-Kubernetes-Tutorial/udemy-note/multi_containers/example/backend:/app -v logs:/app/logs -v /app/node_modules --rm -d -p 80:80 --network goals-net  goals-node
```


## Authentication 
db에 authentication을 부여한다. 
```console
$ docker run --name mongodb -v data:/data/db --rm -d --network goals-net -e MONGO_INITDB_ROOT_USERNAME=max -e MONGO_INITDB_ROOT_PASSWORD=secret mongo
```
backend의 `app.js`의 mongodb 주소를 username, password를 포함하여 `mongodb://max:secret@mongodb:27017/course-goals?authSource=admin`로 설정한다.

```console
$ docker run --name goals-backend  -v /home/leeyujin/yujin-dev/Docker-Kubernetes-Tutorial/udemy-note/multi_containers/example/backend:/app -v logs:/app/logs -v /app/node_modules -e MONGODB_USERNAME=max --rm -d -p 80:80 --network goals-net  goals-node
```

## Live Source Code Updates 
실시간으로 소스 코드를 반영하여 front를 확인하기 위해 아래와 같이 실행한다.
```console
$ docker run /home/leeyujin/yujin-dev/Docker-Kubernetes-Tutorial/udemy-note/multi_containers/example/frontend/src://app/src --name goals-frontend --rm -p 3000:3000 -it goals-react