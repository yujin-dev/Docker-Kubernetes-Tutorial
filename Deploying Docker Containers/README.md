#  Deploying Docker Containers 

- development : 로컬에서 `Bind Mounts`를 이용해 실행중인 컨테이너에 호스트된다.
- production : 컨테이너가 standalone으로 실행되기에 소스코드가 remote machine에 있으면 안됨. `COPY`를 이용해 image 에 code를 복사한다.

## 인스턴스 연결
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