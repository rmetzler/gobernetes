# Set up Kubernetes cluster

Tested with:<br>

_kubeadm: v1.13.0_<br>
_kubectl: v1.13.0_<br>
_kubernetes: v1.13.5_<br>
_nodes: CentOS 7.6.1810 (Core)_<br>

## Prepare nodes / install kubeadm

Read official documentation - [Before you begin](https://kubernetes.io/docs/setup/independent/install-kubeadm/)

* All nodes requirement:
	* Full network connectivity between all machines in the cluster
	* Hostname, MAC address and product_uuid must be unique
	* Check if [required ports](https://kubernetes.io/docs/setup/independent/install-kubeadm/#check-required-ports) are not used
	* Add SG inbound rule ALL TCP, Source: 10.0.0.0/16 (VPC CIDR)
	* Disable swap `swapoff -a` (EC2 has no swap by default)
	* Check if SELinux is enabled. `sestatus` `getenforce`
	* Install Docker (18.06.1-ce) recommended version
		* `yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`
		* `yum update && yum install docker-ce-18.06.1.ce`
	* Install [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm/), [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)  and kubelet (check versions and which yum repository should be added)
	* Take a look at [kubeadm version skew policy](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#version-skew-policy)  and [all components version skew policy](https://kubernetes.io/docs/setup/version-skew-policy/)
	* Follow notes for setting up sysctl: `net.bridge.bridge-nf-call-iptables` (only for CentOS)
	* Run docker & kubelet via systemctl. Also make them start at system boot:
		* `systemctl start docker` `systemctl enable docker`
		* `systemctl start kubelet` `systemctl enable kubelet`
	
## Create a single master cluster with kubeadm
* Master:
	* ⚠️ first try with `--dry-run` (output what would be done)
	* `sudo kubeadm init --pod-network-cidr=10.244.0.0/16` 
	* Add `--apiserver-cert-extra-sans` for setting up kubectl remote usage
	* Init will give you the output how to set up `~/.kube/config`
	* Use coreos/Flannel as [network add-on](https://kubernetes.io/docs/concepts/cluster-administration/addons/)  - `kubectl apply -f extras/flannel.yml` [used manifest](https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml) It will create DaemonSet which makes sure flannel pod will be created on every single node added to cluster
* Workers:
	* Join worker nodes to cluster with cmd from kubeadm init output
* Resulting pods:
	* kube-apiserver
	* kube-controller-manager
	* kube-scheduler
	* kube-proxy (one for each node)
	* etcd
	* 2 coredns (will not work without pod network)
	* flannel (one for each node - NEEDS to be applied manually)

* If `k config view` does not return anything - `export KUBECONFIG=/etc/kubernetes/admin.conf` or look at this [setting config](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/#set-the-kubeconfig-environment-variable)
* [Optional] Use [heptio/sonobuoy](https://github.com/heptio/sonobuoy) to diagnose K8s cluster and run conformance tests:
	* `export GOPATH=$HOME/go`
	* `export GOROOT=/usr/local/bin/go/`
	* `export PATH=$GOROOT/bin:$GOPATH/bin:$PATH`
	* `./go/bin/sonobuoy run`
	* After `sonobuoy delete` delete all docker images pulled
	
## Using kubectl remotely
* To use kubectl remotely open up kube API server port: 6443, SCP whole .kube folder to local machine. Then, it is possible to use kubectl with `--insecure-skip-tls-verify`.
* Instead of coping whole `.kube` folder; you can just copy `certificate-authority-data`, `client-certificate-data` & `client-key-data` into your local .kube/config file
* To do this [securely](https://stackoverflow.com/a/46360852/2884309) ; for me restarting kubeadm and initializing it with `--apiserver-cert-extra-sans` worked.
