### Images are Read-Only
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