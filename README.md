# Salt-Minion-Windows
An independent salt minion container using official Windows-Server-2025 image for use with [salt-formula-x (Salt-Master)](https://github.com/build-boxes/salt-formula-x) and the Compose file [Docker/Podman Compose file for Salt](https://github.com/build-boxes/salt-compose.git)

By default the  Official Windows-Server Container images do not have a Graphical Desktop (GUI).

## Requirements

- Windows Host OS
- Docker Desktop, with Windows Container Engine Running

## Ports Exposed
Exposes following ports for minion communication with Salt-Master.
```
EXPOSE 4505 4506
```

## Build Docker Image
```
docker build . -t hammadrauf/saltmw
```

## Launching the Container (Locally)
```
docker run --name saltmw01 -d saltmw

OR launch as a Daemon:

docker run --name saltmw01 -d -it saltmw

```

## Connecting to a Running Daemon Instance

For Powershell session:

```
docker exec -it saltmw01 C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
```
OR for CMD session:

```
docker exec -it saltmw01 cmd
```

## Launching the Container (From Docker.io)
```
docker run -d --name saltmw01 docker.io/hammadrauf/saltmw
```

## Checking the Container IP Address (Not assigned)
```
docker inspect saltmw01 | Select-String "IPAddress"
```

## Stop and Destroy the Container
```
docker stop saltmw01
OR
docker container stop saltmw01

docker container rm saltmw01
docker image rm hammadrauf/saltmw
```

## List and Delete Unwanted Images
```
docker image ls

docker image rm <Image-ID01> [<Image-ID02>/<ImageName-02> ...}
```

## Manually Upload Image to Repositories
You should have an account with DockerHub.io or Quay.io to push built images.
```
docker push ....
```

## Pairing the independent Container based Salt Master

The Salt Master always runs in a Linux Host or Container. 

1. On a Windows Host computer first launch the hammadrauf/saltx Salt-Master container as a Linux container in Docker Desktop.
2. Then right-click the Docker icon in System-tray and “switch to Windows container engine”. The linux salt-master hammadrauf/saltx will keep running in the background.
3. Then launch this Windows Engine Salt-Windows-Minion hammadrauf/saltmw.
