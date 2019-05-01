### Kustomize
* `kustomize build go-ws/kustomize/base/ | kubectl apply -f -`
* `kustomize build go-ws/kustomize/overlays/development/ | kubectl apply -f -`

PS. Since 1.14, kubectl contains [kustomize](https://kubernetes.io/docs/concepts/overview/object-management-kubectl/kustomization/) command. 