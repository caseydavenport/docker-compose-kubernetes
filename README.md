# [Calico](http://projectcalico.org) and [Kubernetes](http://kubernetes.io) using [Docker Compose](https://www.docker.com/docker-compose)

## Starting the Cluster
This guide installs an all-in-one single node Kubernetes cluster using Docker on Linux or OSX.

The following will also be deployed:

 * The Kubernetes [DNS addon](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns)
 * [Kube UI](http://kubernetes.io/v1.0/docs/user-guide/ui.html)


### Linux

##### Requirements
- [docker-compose](https://docs.docker.com/compose/install/)
- [kubectl](http://storage.googleapis.com/kubernetes-release/release/v1.1.7/bin/linux/amd64/kubectl)

On Linux we'll run Kubernetes using a local Docker Engine. To launch the cluster:

```sh
./kube-up.sh
```

#### OSX

On OS X we'll launch Kubernetes inside a [boot2docker](http://boot2docker.io) VM via [Docker Machine](https://docs.docker.com/machine/). 

##### Requirements:
- [virtualbox](https://www.virtualbox.org/wiki/Downloads)
- [docker tools](https://docs.docker.com/mac/step_one/)
- kubectl: `brew install kubernetes-cli`

First start your boot2docker VM:

```sh
docker-machine start <name>
eval "$(docker-machine env $(docker-machine active))"
```

Then, launch the Kubernetes cluster in boot2docker via Docker Machine:

```sh
./kube-up.sh
```

The script will set up port forwarding so that you can use `kubectl` locally without having to ssh into boot2docker.

## Check if Kubernetes Is Running

```sh
kubectl cluster-info
Kubernetes master is running at http://localhost:8080
KubeUI is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kube-ui
```

## Accessing Kube UI

You can access Kube UI at http://localhost:8080/ui.

## To destroy the cluster

```sh
./kube-down.sh
```

This will also remove any services, replication controllers and pods that are running in the cluster.
