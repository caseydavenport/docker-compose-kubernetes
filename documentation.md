# Docker-compose-kubernetes Getting Started Guide

##**Prerequisites**
> Install the latest version of Virtual Box from [here](https://www.virtualbox.org/wiki/Downloads)  
> Install the latest version of Docker Tool from [here](https://docs.docker.com/mac/step_one/)  
> Install latest version of Kubernetes CLI via Homebrew: `brew install kubernetes-cli`


##**Setup**
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
$ eval "$(docker-machine env dev)"
`

At this point your shell should be configured to use your `dev` docker vm. Verify this by checking the output of `docker-machine ls` it should look like this.

```
NAME   ACTIVE   DRIVER       STATE     URL                         SWARM   ERRORS
dev    *        virtualbox   Running   tcp://192.168.99.104:2376 
```

Now clone the docker-compose-kubernetes repo with: 
`$ git clone git@github.com:30x/docker-compose-kubernetes.git`

and cd into it with:  
`$ cd docker-compose-kubernetes`

To spin up the kubernetes cluster run `./kube-up.sh`  
Confirm that the cluster is running by verifying the output of `kubectl cluster-info` it should like this.

```
Kubernetes master is running at http://localhost:8080  
KubeUI is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kube-ui
```

You can also see the standard kubernetes containers running in docker by checking the output of `docker ps`  
It should look similar to this.

```
CONTAINER ID        IMAGE                                                COMMAND                  CREATED             STATUS              PORTS               NAMES
3f5156ae5cd1        gcr.io/google_containers/kube-ui:v4                  "/kube-ui"               5 minutes ago       Up 5 minutes                            k8s_kube-ui.ff493609_kube-ui-v4-oud32_kube-system_8c3e5e1b-c380-11e5-ac91-3a34d3b584c0_bc248302
cecc610a7670        gcr.io/google_containers/pause:0.8.0                 "/pause"                 5 minutes ago       Up 5 minutes                            k8s_POD.68110139_kube-ui-v4-oud32_kube-system_8c3e5e1b-c380-11e5-ac91-3a34d3b584c0_9da631de
6d9ef218efa7        gcr.io/google_containers/hyperkube:v1.1.3            "/hyperkube controlle"   5 minutes ago       Up 5 minutes                            k8s_controller-manager.6994021e_k8s-master-127.0.0.1_default_e1376f76a07b85e8b0e4c363ff0fa6c1_3847c91c
339f38eb91f0        gcr.io/google_containers/hyperkube:v1.1.3            "/hyperkube apiserver"   5 minutes ago       Up 5 minutes                            k8s_apiserver.9de8159f_k8s-master-127.0.0.1_default_e1376f76a07b85e8b0e4c363ff0fa6c1_fdc8c6a0
b8c73b7725cd        gcr.io/google_containers/hyperkube:v1.1.3            "/hyperkube proxy --m"   5 minutes ago       Up 5 minutes                            kubernetes_proxy_1
e67284325e84        gcr.io/google_containers/etcd:2.2.1                  "/usr/local/bin/etcd "   5 minutes ago       Up 5 minutes                            kubernetes_etcd_1
bd1aa3472764        gcr.io/google_containers/hyperkube:v1.1.3            "/hyperkube scheduler"   6 minutes ago       Up 6 minutes                            k8s_scheduler.ed57faf5_k8s-master-127.0.0.1_default_e1376f76a07b85e8b0e4c363ff0fa6c1_f3c43a27
f6809dfc8d69        gcr.io/google_containers/pause:0.8.0                 "/pause"                 6 minutes ago       Up 6 minutes
```

##**Destroying the Cluster**

To destroy the cluster run `./kube-down` within the `docker-compose-kubernetes` directory. 


##**Local Registry**

The cluster automatically starts a docker container with a local registry.  

To use this registry you first tag images:

```
docker tag <image-name> localhost:5000/<image-name>
```

Then push the image to the registry:

```
docker push localhost:5000/<image-name>
```

You can now use images as though they came from dockerhub. Simply prepend the image name with `localhost:5000/` in your kubernetes `.yaml` files. 