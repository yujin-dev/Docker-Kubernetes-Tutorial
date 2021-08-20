# Managing Data & Volumes

## Data
- Application : Read-only, image에 저장된다.
- Temporary Application Data: 실행중인 컨테이너에 포함되며 임시 파일이나 메모리에 저장된다. Read + Write로 컨테이너에 임시적으로 저장된다.
- Permanent Application Data: 실행중인 컨테이너에 포함되며 파일이나 DB에 저장된다. Read + Write로 컨테이너와 Volumes에 저장된다.

