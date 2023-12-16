# 1. introduction.
###### this repo including ubuntu docker image with SSH and VNC support.
    
# 2. how to build and run.
###### 2.1 ubuntu18.04-kasmvnc-amd64
    docker build --force-rm --tag ubuntu18.04-kasmvnc-amd64:master --file ubuntu18.04-kasmvnc-amd64.dockerfile .
    docker run -itd -p :22 -p :6901 --name ubuntu18.04-kasmvnc-amd64 ubuntu18.04-kasmvnc-amd64:master

###### 2.2 ubuntu20.04-kasmvnc-amd64
    docker build --force-rm --tag ubuntu20.04-kasmvnc-amd64:master --file ubuntu20.04-kasmvnc-amd64.dockerfile .
    docker run -itd -p :22 -p :6901 --name ubuntu20.04-kasmvnc-amd64 ubuntu20.04-kasmvnc-amd64:master

###### 2.3 ubuntu22.04-kasmvnc-amd64
    docker build --force-rm --tag ubuntu22.04-kasmvnc-amd64:master --file ubuntu22.04-kasmvnc-amd64.dockerfile .
    docker run -itd -p :22 -p :6901 --name ubuntu22.04-kasmvnc-amd64 ubuntu22.04-kasmvnc-amd64:master

# 3. how use access container.
###### 3.1 SSH (when port = 49922).
     ssh -p 49922 root@192.168.1.100

###### 3.2 VNC (when port = 46901).
     https://192.168.1.100:46901


# 3. user scenario.
###### 3.1 install ffmpeg in those base images to show video or picture.
###### 3.2 install pycharm in those base images and got an ubuntu based python develop environment.
