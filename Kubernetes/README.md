# Kubernetes

## 기능
- container 충돌하거나 다운될 수 있음 -> container health checks 
- scale up, down가 필요 -> autoscalinag
- traffic 분산이 필요 -> load balancer

## 구조
Worker Note는 pod라는 컨테이너를 실행시키는 노드이다.
node는 machines, virtual instance를 의미한다.

여러 개의  worker node를 통해 여러 컨테이너를 실행할 수 있는데 쿠버네티스는 Master Node가 이를 총괄 관리한다.

모든 worker node와 master node가 Cluster가 연결된다.

### Worker node 
- kubelet : Master, Worker Node는 kubelet을 통해 소통한다. 
- kube-proxy : node와 pod network를 관리한다.

### Master node
- API server : worker node를 소통하는 kubelet을 위한 API가 있다.
- Scheduler : worker node를 모니터링한다.
- Kube-Controller-Manager : pod 갯수가 유지되는지 확인하고 worker node를 제어한다.
- Cloud-Controller-Manager