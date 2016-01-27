# Getting Started with Kubernetes using Docker Compose

##**OSX**

####**Prerequisites**

> Install the latest version of Virtual Box from [here](https://www.virtualbox.org/wiki/Downloads)  
> Install the latest version of Docker Tool from [here](https://docs.docker.com/mac/step_one/)  
> Install latest version of Kubernetes CLI via Homebrew: `brew install kubernetes-cli`

####**Setup**
First you will need to create docker vm using docker-machine.  
`
$ docker-machine create --driver virtualbox dev  
`

You can find out how to connect to this machine with:  
`
$ docker-machine env dev
`

This should tell you to type the following command:  
`
eval "$(docker-machine env dev)"
`

At this point your shell should be configured to use your `dev` docker vm.  

Verify this by checking the output of `docker-machine ls` it should look like this.

```
NAME   ACTIVE   DRIVER       STATE     URL                         SWARM   ERRORS
dev    *        virtualbox   Running   tcp://192.168.99.104:2376 
```  

##**Kubernetes Startup**
 
> ###Note that if you have an existing kubectl config you will need to move it.  

```sh
mv ~/.kube ~/.kube-backup
```


Now clone the docker-compose-kubernetes repo:
 
```sh
git clone git@github.com:30x/docker-compose-kubernetes.git
```

and cd into it 

```sh
cd docker-compose-kubernetes
```

To spin up the kubernetes cluster run 

```sh
./kube-up.sh
``` 

Confirm that the cluster is running by verifying the output of 

```sh
kubectl cluster-info
``` 
It should look like this:

```
Kubernetes master is running at http://localhost:8080  
KubeUI is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kube-ui
```

You can also see the standard kubernetes containers running in docker by checking the output of 

```sh
docker ps
```  
It should look similar to this:

```sh
CONTAINER ID        IMAGE                                                COMMAND                  CREATED             STATUS              PORTS                    NAMES
2b15564d96ef        gcr.io/google_containers/kube-ui:v4                  "/kube-ui"               8 seconds ago       Up 7 seconds                                 k8s_kube-ui.ff493609_kube-ui-v4-474bz_kube-system_0ec50791-c545-11e5-be2b-167664e2ee72_e900ee0c
40a8fee83fda        gcr.io/google_containers/pause:0.8.0                 "/pause"                 8 seconds ago       Up 7 seconds                                 k8s_POD.68110139_kube-ui-v4-474bz_kube-system_0ec50791-c545-11e5-be2b-167664e2ee72_9c0c3e64
6a3e45b1c95b        gcr.io/google_containers/hyperkube:v1.1.3            "/hyperkube scheduler"   10 seconds ago      Up 9 seconds                                 k8s_scheduler.ed57faf5_k8s-master-127.0.0.1_default_e1376f76a07b85e8b0e4c363ff0fa6c1_e4e2be06
8364130e9bc5        gcr.io/google_containers/hyperkube:v1.1.3            "/hyperkube apiserver"   10 seconds ago      Up 10 seconds                                k8s_apiserver.9de8159f_k8s-master-127.0.0.1_default_e1376f76a07b85e8b0e4c363ff0fa6c1_c04e1d76
d0d14cc69e58        gcr.io/google_containers/hyperkube:v1.1.3            "/hyperkube controlle"   10 seconds ago      Up 10 seconds                                k8s_controller-manager.6994021e_k8s-master-127.0.0.1_default_e1376f76a07b85e8b0e4c363ff0fa6c1_c812f471
820a60e16d06        gcr.io/google_containers/pause:0.8.0                 "/pause"                 10 seconds ago      Up 10 seconds                                k8s_POD.6d00e006_k8s-master-127.0.0.1_default_e1376f76a07b85e8b0e4c363ff0fa6c1_8a46e897
63f3c86c4ad9        registry:2                                           "/bin/registry /etc/d"   11 seconds ago      Up 11 seconds       0.0.0.0:5000->5000/tcp   kubernetes_registry_1
c0ef69819beb        gcr.io/google_containers/etcd:2.2.1                  "/usr/local/bin/etcd "   11 seconds ago      Up 11 seconds                                kubernetes_etcd_1
80c224f66c7f        gcr.io/google_containers/hyperkube:v1.1.3            "/hyperkube proxy --m"   11 seconds ago      Up 11 seconds                                kubernetes_proxy_1
cf45b76683da        gcr.io/google_containers/hyperkube:v1.1.3            "nsenter --target=1 -"   11 seconds ago      Up 11 seconds                                kubernetes_master_1
7d7996ee5c69        gcr.io/google_containers/skydns:2015-10-13-8c72f8c   "/skydns --machines=h"   11 seconds ago      Up 11 seconds                                kubernetes_skydns_1
33aeed9d1aec        gcr.io/google_containers/kube2sky:1.12               "/kube2sky --kube_mas"   12 seconds ago      Up 11 seconds                                kubernetes_kube2sky_1
```

##**Destroying the Cluster**

To destroy the cluster run 

```sh
./kube-down
``` 
within the `docker-compose-kubernetes/` directory. 


##**Local Registry**

The cluster automatically starts a docker container with a local registry.  

To build images run:  

```sh
docker build -t <image-name> .
```

Then tag them:

```sh
docker tag -f <image-name> localhost:5000/<image-name>
```

Then push the image to the registry:

```sh
docker push localhost:5000/<image-name>
```

The images will now be available to your kubernetes cluster. Simply prepend the image name with `localhost:5000/`