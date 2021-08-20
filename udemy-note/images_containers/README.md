# Docker Images & Containers
- example 1 : https://github.com/yujin-dev/Docker-Kubernetes-Tutorial/tree/master/udemy-note/example_1
- example 2 : https://github.com/yujin-dev/Docker-Kubernetes-Tutorial/tree/master/udemy-note/example_2
- example 3 : https://github.com/yujin-dev/Docker-Kubernetes-Tutorial/tree/master/udemy-note/example_3


### `docker ..` 실행 시 오류
```
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json": dial unix /var/run/docker.sock: connect: permission denied
```
아래와 같이 실행하여 해결한다. 
```console
$ sudo chmod 666 /var/run/docker.sock
```

### 도커 이미지 빌드
```console
$ docker build .
Step 1/7 : FROM node:14
...

Status: Downloaded newer image for node:14
 ---> 256d6360f157
Step 2/7 : WORKDIR /app
 ---> Running in aa6ab8e9562f
Removing intermediate container aa6ab8e9562f
 ---> f094a3aefaa1
Step 3/7 : COPY package.json .
 ---> 989373d6d886
Step 4/7 : RUN npm install
 ---> Running in b7e49d9bb26b
npm notice created a lockfile as package-lock.json. You should commit this file.
npm WARN docker-complete@1.0.0 No description

added 50 packages from 37 contributors and audited 50 packages in 2.633s
found 0 vulnerabilities

Removing intermediate container b7e49d9bb26b
 ---> 8daee70a02fe
Step 5/7 : COPY . .
 ---> d9f1787c5868
Step 6/7 : EXPOSE 3000
 ---> Running in 595601beae69
Removing intermediate container 595601beae69
 ---> d0a9af4ed85c
Step 7/7 : CMD [ "node", "app.mjs" ]
 ---> Running in 1a6306dd4fa4
Removing intermediate container 1a6306dd4fa4
 ---> 90db42db7ea2
Successfully built 90db42db7ea2
```

### 컨테이너 실행
`docker run`을 통해 새로운 컨테이너를 실행한다.
OS 와 컨테이너를 연결하기 위한 port를 명시해준다. 컨테이너 port 를 열어주어 외부에서 접속할 수 있도록 한다. 
`-p {로컬 port}:{컨테이너 port}`를 설정하여 port를 매핑한다.
```console
$ docker run -p 3000:3000 90db42db7ea2AA
``` 
docker 닫으려면 
```console
$ docker stop 90db42db7ea2AA
```

## Images are Read-Only
소스코드 변경과 같은 image를 구성하는 요소가 바뀌면 새로 빌드해야 한다.

### Using cache
rebuild할 때 바뀐 사항이 없는 부분은 cache에서 바로 가져온다.
Dockerfile의 각 line은 하나의 layer로 구분되어 필요한 부분만 다시 로드된다.
```
Sending build context to Docker daemon  14.85kB
Step 1/6 : FROM node
 ---> c66552d59c4b
Step 2/6 : WORKDIR /app
 ---> Using cache
 ---> 351416b5b1a6
Step 3/6 : COPY . /app
 ---> f65516ec572b
Step 4/6 : RUN npm install
 ---> Running in e6ffc298c808

added 50 packages, and audited 51 packages in 2s

found 0 vulnerabilities
npm notice 
npm notice New patch version of npm available! 7.20.3 -> 7.20.6
npm notice Changelog: <https://github.com/npm/cli/releases/tag/v7.20.6>
npm notice Run `npm install -g npm@7.20.6` to update!
npm notice 
Removing intermediate container e6ffc298c808
 ---> 7dfaa563b014
Step 5/6 : EXPOSE 80
 ---> Running in b56c7a447c13
Removing intermediate container b56c7a447c13
 ---> 8aaf44f1eccf
Step 6/6 : CMD ["node", "server.js"]
 ---> Running in 1ec79a7742e2
Removing intermediate container 1ec79a7742e2
 ---> 9fbad7235d7c
Successfully built 9fbad7235d7c
```
example_1의 Dockerfile의 `COPY . /app` 순서를 `RUN npm install` 다음으로 변경하면 처음 한번만 `package.json` 기반으로 `npm install` 하여 이후 동일하게 적용된다. 따라서 `npm` 설치를 rebuild를 하지 않아도 되어 build 속도를 높일 수 있다.

```dockerfile
...
COPY package.json /app
RUN npm install 
COPY . /app
...
```

## Attached vs Detached Mode
- Attached : foreground에서 실행되는 것으로 로그를 확인할 수 있다.
- Detached : background에서 실행된다.
```console
$ docker run -p 3000:80 -d 9fbad7235d7c
```
attached mode로 변환 가능하다.
```console
$ docker attach {Container ID}
```
detached mode에서 
```console
$ docker logs {Container ID}
```
로 로그를 확인할 수 있다.

## Entering Interactive Mode

 input을 추가하려면 `-it` 옵션을 추가하여 터미널로 interactive mode를 사용하도록 한다.
```console
$ docker -it run {container ID}
```
### start docker as listen and write mode
- `-a` : attached mode
- `-i`: interative mode
```console
$ docker start -a -i {container}
```

## Deleting Images & Containers
image를 삭제하기 위해서는 빌드된 container를 먼저 삭제해야 한다.
```console
$ docker rm
$ docker rmi 
$ docker image prune
```

### 컨테이너 stop시 자동 삭제
아래는 `0ff39993a144` 컨테이너를 detached mode로 해당 포트를 열어 실행하되 stop하면 자동으로 삭제되게 한다.
```console
$ docker run -p 3000:80 -d --rm 0ff39993a144
```

## Insecting Images
컨테이너에 대한 general configuration을 파악할 수 있다.
```console
$ docker image inspect 9ae309a7a024
...
            "Layers": [
                "sha256:a881cfa23a7842d844818a1cb4d8460a7396b94fdc0bc4091f8d79b8f4f81c3e",
                "sha256:05103deb4558d56fd1de73608ad22550a54dbefb0d47075f0c3befd2ed7d66e4",
                "sha256:21b17a30443eda5d88894fada42fb1e4e1de37047047a4efca67cd52dfb577ac",
                "sha256:9889ce9dc2b04554ac95d788395975e0401d33591d00460c411d36a1befe9e1d",
                "sha256:21abb8089732cb5e11080477cca711501278d119b0c0ae37bc9325f2a6402d53",
                "sha256:e80eb58cd4e134afebdda1be0dd4fa42c230d492f3fe10e3be52c97c5a2f93d1",
                "sha256:6ec1e18e96a4a24073c803c2bcdd3247346d6307de78578914356c4a243fe15d",
                "sha256:583768e6b0f988a05c3eb242ed354ff0aefc7622b6c37de3d9f3b9a7da655c83",
                "sha256:ae3e9b5276f9c5dff99eac2af59bd018b96327c54fa8c981045591ab56530212",
                "sha256:42300d90984b317801cef3926e47cee28ba54b5237850001effd5f5e28e48e5d",
                "sha256:860e30cb8e809cafe61441a0c3b7e57eb4bbf611a34a17ed56253a953e90f805"
            ]

...
```
Dockerfile의 각 line에 따라 layer의 hash key가 포함되어 있다.

## Copying into / from containers 
`test.txt` 파일을 `zealous_antonelli`의 `test`폴더에 복사한다.
```console
$ docker cp test.txt zealous_antonelli:/test
```
`zealous_antonelli`의 `test.txt` 파일을 로컬 현재 위치에 복사한다.
```console
$ docker cp zealous_antonelli:/test .
```
`docker cp`는 컨테이너를 재실행하지 않아도 복사 가능한 장점이 있다.
컨테이너의 log 파일을 외부로 복사할 때 유용하다.

## Naming & Tagging 
```console
$ docker run -p 3000:80 -d --rm --name {my_container_name} f71d3d70d705
```
docker images에 대해 `goals:latest`라고 naming할 수도 있다.
```console
$ docker build -t goals:latest .
$ docker ps
REPOSITORY    TAG       IMAGE ID       CREATED          SIZE
goals         latest    f71d3d70d705   11 minutes ago   912MB
$ docker run -p 3000:80 -d --rm --name {my_container_name} goals:latest
```

## Sharing Images & Containers
- Dockfile로 image를 공유하여 build할 수 있고 컨테이너 자체를 공유하여 바로 실행할 수 있다.
- Dockerhub을 통해 images를 올려 git처럼 `pull` / `push`로 사용 가능하다.
- `docker pull {image_name}`은 image의 로컬 이미지와 비교하여 가장 최신 버전으로 가져오지만 `docker run {image_name}`은 최신 버전을 체크하진 않는다.