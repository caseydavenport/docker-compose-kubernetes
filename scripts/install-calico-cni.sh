#!/bin/sh

# Versions of Calico to install.
CALICOCTL_VERISON=v0.19.0
CALICO_CNI_VERSION=v1.3.0

# Create necessary directories.
sudo mkdir -p /etc/cni/net.d
sudo mkdir -p /opt/cni/bin
sudo mkdir -p /opt/bin
sudo mkdir -p /var/run/calico
sudo mkdir -p /var/log/calico

# Ensure the network config file exists.
sudo cat >10-calico.conf <<EOF
{
    "name": "calico-k8s-net",
    "type": "calico",
    "etcd_authority": "127.0.0.1:4001",
    "ipam": {
        "type": "calico-ipam"
    },
    "policy": {
        "type": "k8s-annotations",
        "k8s_api_root": "http://127.0.0.1:8080/api/v1"
    }
}
EOF
sudo mv 10-calico.conf /etc/cni/net.d

# Download the CNI plugin.
if [ ! -f /opt/cni/bin/calico ]; then
	sudo wget -O /opt/cni/bin/calico https://github.com/projectcalico/calico-cni/releases/download/${CALICO_CNI_VERSION}/calico
	sudo chmod +x /opt/cni/bin/calico
fi

# Download the calicoctl tool.
if [ ! -f /usr/local/bin/calicoctl ]; then
	sudo wget -O /usr/local/bin/calicoctl https://github.com/projectcalico/calico-containers/releases/download/${CALICOCTL_VERISON}/calicoctl
	sudo chmod +x /usr/local/bin/calicoctl
fi

# Ensure proper kernel modules installed. 
sudo modprobe -a xt_set ip6_tables
