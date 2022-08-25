#!/bin/bash


INIT_HOST="no"

if [ $# -ge 1 ]; then
	INIT_HOST=$1
fi
#######################################################################################
# INIT_HOST
if [ ${INIT_HOST} == "yes" ]; then

	mkdir -p docker-root
	mkdir -p docker-etc-docker
	mkdir -p docker-var-lib-docker
	mkdir -p docker-etc-cni
	mkdir -p docker-opt-cni
	mkdir -p docker-usr-libexec-kubernetes
	mkdir -p docker-var-lib-kubelet
	mkdir -p docker-var-log
	
	sudo cp -arf /root/* ./docker-root
	sudo cp -arf /etc/docker/* ./docker-etc-docker
	sudo cp -arf /var/lib/docker/* ./docker-var-lib-docker
	sudo cp -arf /etc/cni/* ./docker-etc-cni
	sudo cp -arf /opt/cni/* ./docker-opt-cni
	sudo cp -arf /usr/libexec/kubernetes/* ./docker-usr-libexec-kubernetes
	sudo cp -arf /var/lib/kubelet/* ./docker-var-lib-kubelet
	sudo cp -arf /var/log/* ./docker-var-log
	
	exit 0
fi

#docker run -d \
docker run -it \
    --init \
    --name docker \
    --hostname docker \
    --restart unless-stopped \
    --privileged \
    -p 127.0.0.1:1000:2375 \
    -v /lib/modules:/lib/modules:ro \
    -v docker-root:/root \
    -v docker-etc-docker:/etc/docker \
    -v docker-var-lib-docker:/var/lib/docker \
    -v docker-etc-cni:/etc/cni \
    -v docker-opt-cni:/opt/cni \
    -v docker-usr-libexec-kubernetes:/usr/libexec/kubernetes \
    -v docker-var-lib-kubelet:/var/lib/kubelet \
    -v docker-var-log:/var/log \
    --tmpfs /run \
    -e MOUNT_PROPAGATION="/" \
    mbentley/docker-in-docker\
    dockerd -s overlay2 -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375



#docker -H tcp://localhost:1000 info
#docker -H tcp://localhost:1000 version

#docker -H tcp://localhost:1000 swarm init
#TOKEN=$(docker -H tcp://localhost:1000 swarm join-token worker -q)
#JOIN_COMMAND="swarm join --token ${TOKEN} $(docker container inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' docker):2377"
#docker -H tcp://localhost:1000 ${JOIN_COMMAND}


#docker kill docker
#docker rm docker
#docker volume rm docker

#docker swarm leave --force

