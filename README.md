# gobernetes

Collection of miscellaneous Kubernetes resources. Tested on both bare-metal AWS and GKE.

## Kubernetes components included:

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
