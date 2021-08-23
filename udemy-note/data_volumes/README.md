# Managing Data & Volumes
### logs 확인
`docker logs {container id OR name}`으로 로그를 확인한다.

## Data
- Application : Read-only, image에 저장된다.
- Temporary Application Data: 실행중인 컨테이너에 포함되며 임시 파일이나 메모리에 저장된다. Read + Write로 컨테이너에 임시적으로 저장된다.
- Permanent Application Data: 실행중인 컨테이너에 포함되며 파일이나 DB에 저장된다. Read + Write로 컨테이너와 Volumes에 저장된다.

## Volumes
컨테이너에 mount된 host machine의 폴더이다. 컨테이너에서 데이터를 read & write하는데 컨테이너가 삭제되도 volume은 남아있다.
volumes에는 anonymous volumes / named volumes가 있는데 named volumes만 영구 지속된다. 하지만 volumes 자체는 docker에 의해 운영되기에 파일의 위치를 알거나 컨테이너 실행 후 수정하여 반영할 수 없다.
- Anonymous Volumes: 단일 컨테이너에 한하며 컨테이너 삭제시 삭제된다.
- Named Volumes: 컨테이너 삭제되어도 존재하며 컨테이너 간에 공유될 수 있다.
- Bind Mounts: host 파일 시스템에 위치하며 컨테이너 삭제와 관련없이 존재한다. 컨테이너 간 공유가 가능하다.

### Anonymous Volumes

Dockerfile에 아래와 같이 volume폴더를 추가한다.
```
VOLUME [ "/app/feedback" ]
```

### Named Volumes
`-v feedback:/app/feedback` 을 추가하여 컨테이너 생성시 host machine의 `feedback`과 컨테이너의 `/app/feedback`을 매핑하여 named volumes를 생성한다.

```console
$ docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback  feedback-node:volumes
```
컨테이너를 stop하고 다시 실행해도 데이터가 살아있음을 확인할 수 있다.

### Bind Mounts
또 다른 외부 데이터 저장소로 bind mounts가 있는데 영구 지속되고 코드 및 데이터가 수정가능하다. 

```console
$ docker run -d -p 3000:80 --name feedback-app -v feedback:/app/feedback -v "/home/leeyujin/yujin-dev/Docker-Kubernetes-Tutorial/udemy-note/data_volumes/example_1:/app" -v /app/node_modules  feedback-node:volumes
```
`-v "/home/leeyujin/yujin-dev/Docker-Kubernetes-Tutorial/udemy-note/data_volumes/example_1:/app"` 추가하면 절대 경로에 있는 폴더를 `/app`에 mount된다. 하지만 로컬에는 `node_modules`가 없기 때문에 오류가 발생하는데 `-v /app/node_modules`를 추가하여 overwrite한다. 
필요한 부분만 컨테이너에서 host machine으로 아웃소싱하여 성능을 높일 수 있다.

컨테이너를 실행 후 `feedback.html`의 문구를 수정하여 페이지를 리로드하면 바뀐 것을 확인할 수 있다.

product 단계보다 develop에서 실시간 반영을 확인하기 위해서 주로 적용한다. 
Dockefile의 `COPY . .`를 제외해도 bind mounts가 포함되면 자동으로 해당 경로가 반영돼 실행된다. 

### Read-only Volumes

- write를 제외하고 read만 가능하도록 하기 위해 bind mounts 부분에 `:ro`를 추가한다.
- `/app/temp` 폴더를 host machine에 overwrite함을 명시하기 위해 `-v /ap/temp`를 추가한다.
```console
$ docker run -d -p 3000:80 --name feedback-app -v feedback:/app/feedback -v "/home/leeyujin/yujin-dev/Docker-Kubernetes-Tutorial/udemy-note/data_volumes/example_1:/app:ro" -v /app/temp -v /app/node_modules  feedback-node:volumes
```

### Docker Volumes
`docker volume ls`로 docker에 의해 관리되는 volumes list를 확인할 수 있다.(Named Volumes인 경우 `VOLUME NAME`이 특정 이름으로 나옴) bind mounts는 host machine에 의한 로컬 파일이기에 나타나지 않는다. 

특정 volume에 대한 정보를 확인할 수 있다. `Mountpoint`에 나타나는 경로는 실제 host에 있는 폴더가 아닌 컨테이너 내부의 가상 경로이다.
```console
$ docker volume inspect feedback
[
    {
        "CreatedAt": "2021-08-23T22:47:48+09:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/feedback/_data",
        "Name": "feedback",
        "Options": null,
        "Scope": "local"
    }
]

```

volume을 제거하기 위해서는 `docker volume rm {volume id OR name}`를 실행하는데 기반이 되는 container를 먼저 제거해야 된다. 