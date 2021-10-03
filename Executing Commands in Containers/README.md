# Utility Containers and Executing Commands in Containers
Utility Containers(비공식 명칭)는 컨테이너를 실행하여 명령어를 실행하고 추가한다.

container 내부에 진입하여 명령어를 실행할 수 있다.
```console
$ docker exec -it inspiring_mayer npm init
```
bind mounts를 추가하여 node 컨테이너를 띄어놓고 코드를 반영할 수 있다.
```console
$ docker run -it -v /home/leeyujin/yujin-dev/Docker-Kubernetes-Tutorial/udemy-note/utility_containers:/app node-util npm init
```
### ENTRYPOINT
Dockerfile에 ENTRYPOINT를 추가하면 해당 명령어를 시작으로 실행할 수 있다.
```console
$ docker run -it -v /home/leeyujin/yujin-dev/Docker-Kubernetes-Tutorial/udemy-note/utility_containers:/app node-util init
```
### docker-compose 활용
`docker-compose.yml`을 생성하여 `docker-compose run `을 실행하여 명령어를 입력할 수 있다.
```console
$ docker-compose run --rm npm init
```
