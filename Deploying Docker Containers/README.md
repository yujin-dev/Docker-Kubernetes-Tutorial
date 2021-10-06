#  Deploying Docker Containers 

- development : 로컬에서 `Bind Mounts`를 이용해 실행중인 컨테이너에 호스트된다.
- production : 컨테이너가 standalone으로 실행되기에 소스코드가 remote machine에 있으면 안됨. `COPY`를 이용해 image 에 code를 복사한다.

## 인스턴스 연결 및 도커 실행
인스턴스 - 연결에서 `SSH 클라이언트` 가이드를 따라한다.
`ssh -i ..`에 따라 원격 호스트에 접속한다.
```console
       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
11 package(s) needed for security, out of 35 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-172-31-44-202 ~]$ 
```

```console
$ sudo yum update -y
$ sudo amazon-linux-extras install docker
```
업데이트 이후 amazon에 한정된 도커 패키지를 설치한다.

### 도커 이미지 hub에 올리기
이미지를 빌드한 후 태크 이름(`node-dep-example`)을 푸쉬하려는 레포 이름과 맞춰 올린다. 
```console
$ docker tag node-dep-example qlcnal0211/node-example-1:tagname
$ docker push qlcnal0211/node-example-1:tagname
```

### 인스턴스 접속하여 이미지 빌드
```console
$ sudo service docker start
$ sudo docker run -d --rm -p 80:80 qlcnal0211/node-example-1:tagname
``` 
도커 이미지를 받아 실행한다. 이 때 인스턴스의 보안 규칙 - 인바운드 규칙에서 HTTP( port 80 )을 열어놓도록 설정한다.