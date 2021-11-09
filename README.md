# Docker Lecture
[Udemy 강의](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/)를 듣고 정리한 공간. 

[ 목록 ]
- [Data Volumes](https://github.com/yujin-dev/Docker-Kubernetes-Tutorial/tree/master/Data%20Volumes)
- [Image Containers](https://github.com/yujin-dev/Docker-Kubernetes-Tutorial/tree/master/Images%20Containers)
- [Larevel PHP Setup 실습](https://github.com/yujin-dev/Docker-Kubernetes-Tutorial/tree/master/Laravel%20Php%20Setup)
- [Multi Containers](https://github.com/yujin-dev/Docker-Kubernetes-Tutorial/tree/master/Multi%20Containers)
- [Networking](https://github.com/yujin-dev/Docker-Kubernetes-Tutorial/tree/master/Networking)
- [Utility Containers](https://github.com/yujin-dev/Docker-Kubernetes-Tutorial/tree/master/Utility%20Containers)

## Docker
container 기술로 containers를 생성하고 관리하는 tool을 의미한다. 도커를 통해 같은 application을 동일한 환경으로 실행할 수 있다.

도커를 사용하면 다음과 같은 장점이 있다.
- Development 환경과 Production 환경을 동일하게 구성할 수 있다.
- 서로 다른 개발 환경을 팀마다 동일하게 세팅할 수 있다.
- 서로 다른 프로젝트에서 버전 충돌 등을 피할 수 있다.

### Virtual Machines 
가상 머신을 사용하면 분리된 환경을 구성할 수 있고 공유 및 복사가 가능한 장점이 있다. 
하지만, 
- OS 환경에 영향을 잘 받고 여러 가상 머신을 띄워놓으면 리소스 할당이 많아진다.
- 공유 및 복사가 어렵다.
- 전제 머신을 캡슐화한다. 

이에 반해 Containers는
- OS 환경에 영향을 덜 받고 빠르며 disk 공간을 적게 가져간다.
- 공유 및 배포가 쉽다.
- 전체 머신보다는 application 및 환경을 캡슐화한다.

## Images vs. Containers
- Containers : 실제 실행되는 소프트웨어 단위(instance)
- Images : containers 탬플릿으로 실제 코드나 tools/runtimes를 포함한다.
Image를 기반으로 여러 container를 생성할 수 있다.

### Containers
- 격리된 환경: 고유의 데이터, 파일 시스템을 갖는다.
- single-task에 집중되어 있다.
- 공유 및 복제가 가능하다.
- stateless: 컨테이너 내부에서 데이터를 저장하나 컨테이너가 삭제되면 데이터도 사라짐
- volumes으로 데이터를 저장할 수 있다.

### Images
- 컨테이너를 위한 blueprints
- code + environment
- read-only
- 공유 가능하고 build할 수 있다.

## Commands
#### Dockerfile 기반으로 이미지 빌드
`docker build -t NAME:TAG .`

#### 이미지 기반으로 컨테이너 실행
`docker run --name NAME --rm -d IMAGE`

#### Docker Hub을 통해 이미지 공유
- `docker push REPOSITORY/NAME:TAG`
- `docker pull REPOSITORY/NAME:TAG`

#### Bind Mounts : host 머신에 연결하여 데이터를 저장
`-v /local/path:/container/path`

#### Volumes: 데이터 보존
`-v NAME:/container/path`

#### Networks
같은 네트워크를 공유하여 컨테이너를 연결할 수 있다.

#### Docker Compose
build를 미리 정의하고 .yml 파일을 실행한다.
- `docker-compose up` : 이미지를 빌드하고 컨테이너를 실행한다.
- `docker-compose down`: 실행중인 컨테이너를 중단한다.  

### Interactive Shell
container 내부적으로 접근하기 위해서는 명령어에 `-it` 옵션을 추가한다.


