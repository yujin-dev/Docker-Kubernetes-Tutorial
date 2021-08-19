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
OS 와 컨테이너를 연결하기 위한 port를 명시해준다. 컨테이너 port 를 열어주어 외부에서 접속할 수 있도록 한다. 
`-p {로컬 port}:{컨테이너} port}`를 설정하여 port를 매핑한다.
```console
$ docker run -p 3000:3000 90db42db7ea2AA
``` 
docker 닫으려면 
```console
$ docker stop 90db42db7ea2AA
```