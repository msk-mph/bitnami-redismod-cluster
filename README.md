# Docker build for redis cluster with modules

![GitHub forks](https://img.shields.io/github/forks/msk-mph/bitnami-redismod-cluster?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/anyili/bitnami-redismod-cluster?style=plastic)
![License](https://img.shields.io/github/license/msk-mph/bitnami-redismod-cluster?style=plastic)

## Overview
[Bitnami docker redis cluster](https://github.com/bitnami/bitnami-docker-redis-cluster) is based on **Debian Buster**, it doesn't include the redis modules. 
[Redismod](https://github.com/RedisLabsModules/redismod) is an official release from Redis Lab that includes all modules. This build is the combination of 
those two images. 

This docker image is based on **Debian Bullseye**, it is not officially supported by Bitnami, but it works. 
We use multi-stage builds by copying prebuild modules from official Redis module releases during the build of redis cluster.
It includes modules:

* Redis Search 
* Redis Json 
* Redis Graph
* Redis Bloom Filter 

The container will load modules during redis server starts.

## Built
```bash
docker build -t redis-with-mod .
```

## Usage
### Docker compose
```shell
docker-compose up -d  
```

### Kubernetes 
The official [bitnami helm chart](https://github.com/bitnami/charts/tree/master/bitnami/redis-cluster) pulls the bitnami docker image
from dockerhub. It is little hacky to make bitnami helm chart using this image. 
Luckily helm chart can be overwritten, we provide the yaml [file](bitnami-redismod-cluster.yaml) to pull this verison of image from dockerhub
You can run the follow `helm` command to deploy redis-cluster with selected modules to k8s
```shell
helm install redismod-cluster bitnami/redis-cluster \ 
-f ./bitnami-redismod-cluster.yaml --namespace redis
```
It assumes you have already created namespace `redis`.


## License

Distributed under the Apache License Version 2.0 License. See [LICNESE](LICENSE) for more information.


## Contact

Anyi Li - [@anyili](https://twitter.com/anyili) - anyili0928@gmail.com

*MSK Medical Physics Computer Service*

