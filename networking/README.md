# Networking : Dockers Communication

컨테이너에서 외부로 소통하는 네트워킹은 다음과 같이 분류할 수 있다.
1. 컨테이너에서 www로 HTTP request
2. 컨테이너에서 host machine으로 request
3. 컨테이너 간 소통

## Container to Host
mongodb 주소를 `'mongodb://host.docker.internal:27017/swfavorites'`와 같이 `host.docker.internal`를 포함하여 명시한다.

## Container to Container
mongodb를 docker로 띄워서 example의 app을 실행한다.
```console
$ docker run -d --name mongodb mongo
```
inspect을 통해 `Networks - IPAddress`로 mongodb 컨테이너 주소를 파악하여 `app.js`에 적용한다.

```console
$ docker container inspect mongodb
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "56bc99376ca34d307c797a455feaf0e8e874961f04b26d01613fa71d2fe2f908",
                    "EndpointID": "df72c69ad21c02492fd6dc6fd951316dca41fe137e1a2361167b7418530c6432",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2", 
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }

```
example을 도커로 run하면 아래와 같이 2개의 컨테이너가 실행 중임을 알 수 있다.
```
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                                       NAMES
6e3f1329f568   favorite-node   "docker-entrypoint.s…"   12 seconds ago   Up 11 seconds   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   favorites
3470affec486   mongo           "docker-entrypoint.s…"   12 minutes ago   Up 12 minutes   27017/tcp                                   mongodb
```

하지만 위의 방식보다 더 편한 방법이 있다.

### `--network`
`network`를 사용하여 컨테이너 내부에서 소통할 network를 생성한다.
```console
$ docker network create favorites-net
$ docker run -d --name mongodb --network favorites-net mongo
```
```console
$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS       NAMES
330ed5ddd9b8   mongo     "docker-entrypoint.s…"   3 seconds ago   Up 2 seconds   27017/tcp   mongodb
```
컨테이너 내부에서 사용하므로 `mongodb` 컨테이너만 나타남을 확인할 수 있다. 

`app.js`의 mongoDB url을 컨테이너 이름으로 추가하여 `'mongodb://mongodb:27017/swfavorites'`로 설정하면 자동으로 주소가 변환된다.

이미지를 빌드한 후 mongodb와 동일한 네트워크를 명시하여 db와 연결한다.
```console
$ docker run --name favorites --network favorites-net -d --rm -p 3000:3000 favorite-node
```



