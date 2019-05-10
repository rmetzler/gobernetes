# gobernetes

Collection of miscellaneous [helper tools](#tools), [Kubernetes resources](#kubernetes-components-included) & [documentations](#documentation). 
<br><br>Tested on both bare-metal AWS and GKE.

[![Say Thanks!](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://saythanks.io/to/Aracki)

## Tools
* [Kustomize](https://kubernetes.io/blog/2018/05/29/introducing-kustomize-template-free-configuration-customization-for-kubernetes/) (now part of kubectl since 1.14)
* [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
* [kubectx + kubens](https://github.com/ahmetb/kubectx) - switch between clusters and namespaces
* [kube-fzf](https://github.com/arunvelsriram/kube-fzf) - search_tail_exec/describe pods with [fzf](https://github.com/junegunn/fzf)
* [kubetail](https://github.com/johanhaleby/kubetail) - tail k8s logs
* [rakkess](https://github.com/corneliusweig/rakkess) - show an access matrix
* [rbac-lookup](https://github.com/reactiveops/rbac-lookup) - find k8s roles and cluster roles
* [kube-capacity](https://github.com/robscott/kube-capacity) - provide an overview of the resource requests/limits
* [ketall](https://github.com/corneliusweig/ketall) - show really all k8s resources
* [kubediff](https://github.com/weaveworks/kubediff) - show differences between running state and version controlled configuration.
* [kubefwd](https://github.com/txn2/kubefwd) - bulk port forwarding k8s services for local dev
* [kube-ps1](https://github.com/jonmosco/kube-ps1) - k8s prompt info for bash and zsh
* [popeye](https://github.com/derailed/popeye) - k8s cluster resource sanitizer

## Kubernetes components included:
* `k8s_manifests/` folder contains all the manifests for k8s components. 
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
* [Bootstrap K8s cluster](docs/02-bootstrap-k8s-cluster.md)
* [Set up GlusterFS](docs/03-set-up-glusterfs.md)
* [Set up Ingress with cert-manager](docs/04-set-up-ingress.md)
* [Set up monitoring with Prometheus and Grafana](docs/05-set-up-monitoring.md)
* [Set up private docker registry](docs/06-set-up-private-registry.md)
