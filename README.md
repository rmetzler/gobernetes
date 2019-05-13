<img src="assets/gobernetes-logo-text.jpeg" align="right" width="300" heigh="auto">

# gobernetes

Collection of miscellaneous [helper tools](#tools), [Kubernetes resources](#kubernetes-components-included), [documentations](#documentation) & [useful commands](#useful-commands). 

<br><br><br><br>

## Tools
* [Kustomize](https://kubernetes.io/blog/2018/05/29/introducing-kustomize-template-free-configuration-customization-for-kubernetes/) (now part of kubectl since 1.14)
* [kubectx + kubens](https://github.com/ahmetb/kubectx) - switch between clusters and namespaces
* [kube-fzf](https://github.com/arunvelsriram/kube-fzf) - findpod/tailpod/execpod/describepod with [fzf](https://github.com/junegunn/fzf)
* [kubetail](https://github.com/johanhaleby/kubetail) - tail k8s logs
* [rakkess](https://github.com/corneliusweig/rakkess) - show an access matrix
* [rbac-lookup](https://github.com/reactiveops/rbac-lookup) - find k8s roles and cluster roles
* [kube-capacity](https://github.com/robscott/kube-capacity) - provide an overview of the resource requests/limits
* [ketall](https://github.com/corneliusweig/ketall) - show really all k8s resources
* [kubediff](https://github.com/weaveworks/kubediff) - show differences between running state and version controlled configuration.
* [kubefwd](https://github.com/txn2/kubefwd) - bulk port forwarding k8s services for local dev
* [kube-ps1](https://github.com/jonmosco/kube-ps1) - k8s prompt info for bash and zsh
* [pop eye](https://github.com/derailed/popeye) - k8s cluster resource sanitizer
* [kubectl cheat sheet](/https://kubernetes.io/docs/reference/kubectl/cheatsheet//)
* [Fish auto completion for kubectl](https://gist.github.com/Aracki/cf422173371d2118ae94bb6821f074e0)

## Kubernetes components included:
`k8s_manifests/` folder contains all the manifests for: 
* Simple web server application written in Go - [go-ws](https://github.com/Aracki/go-ws)
* MongoDB
* Ingress Controllers - in order for the Ingress resources to work _(read this [Bare metal considerations](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/#bare-metal-considerations))_
   * [Nginx](https://github.com/kubernetes/ingress-nginx)
   * [Traefik](https://docs.traefik.io/user-guide/kubernetes/)
* [Monitoring stack](https://github.com/coreos/prometheus-operator)
   * Prometheus   
   * Alert Manager
   * Grafana
* CI/CD stack
   * [Jenkins](k8s_manifests/jenkins)
   * [Keel](k8s_manifests/keel)
* [cert-manager](https://github.com/jetstack/cert-manager/) - for automated provisioning TLS certs for both staging/production environments
* Kubernetes [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) & [ConfigMaps](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-a-configmap) for storing secret and non-secret configurations

## Documentation:
* [Bootstrap AWS infrastructure](docs/01-bootstrap-aws-infrastructure.md)
* [Bootstrap K8s cluster with kubeadm](docs/02-bootstrap-k8s-cluster.md)
* [Set up GlusterFS](docs/03-set-up-glusterfs.md)
* [Set up Ingress + TLS termination with cert-manager](docs/04-set-up-ingress.md)
* [Set up monitoring with Prometheus and Grafana](docs/05-set-up-monitoring.md)
* [Set up private docker registry](docs/06-set-up-private-registry.md)

## Useful commands
* List all resources in a namespace: `kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n <namespace>`
* Gets IPs of pods: `kubectl get pods --selector=app=go-ws -o jsonpath='{.items[*].status.podIP}'`
* List all containers in k8s cluster: `kubectl get pods -o jsonpath={.items[*].spec.containers[*].name} --all-namespaces`
* Activate these with **kube-fzf**:
	* `findpod` + `describepod` + `execpod` + `tailpod`
* Kill pod forcefully:
	* `kubectl delete pods <pod> --grace-period=0 --force`
	* `kubectl patch pod <pod> -p '{"metadata":{"finalizers":null}}'` 
* Replace resource forcefully: `kubectl replace --force -f go-web-server.yml`
* Print the supported API versions/resources: 
	* `kubectl api-versions`
	* `kubectl api-resources` 
* Overwriting the existing labels: `kubectl label --overwrite pods foo status=unhealthy`
* Show the default values for kubelet: `kubeadm config print-default --api-objects KubeletConfiguration`
* Update existing ConfigMap based on a file: 
	```
	kubectl create configmap traefik-conf --from-file=traefik.toml --dry-run -o yaml | kubectl replace configmap traefik-conf -f - -n traefik
	``` 
