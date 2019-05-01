# Ingress
* Read [Bare-metal considerations¶](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/)
* Example of exposing service with ingress:
	* `k apply -f go-ws/ingress.yml` (Ingress resource)
	* `k apply -f ingress/mandatory.yaml` (Ingress controller + ConfigMaps + Roles…)
	* `k apply -f ingress/nginx-service.yml` (Nginx NodePort Service)
    * Add `nginx.ingress.kubernetes.io/ssl-redirect: "false"` to Ingress if TLS is not enabled ⚠️ 
* If consider  something in front of NodePort services look at [using a self provisioned edge](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/#using-a-self-provisioned-edge)
* Ingresses [comparison](https://kubedex.com/ingress/)

## TLS ingress termination with cert-manager
* For [jetstack/cert-manager](https://cert-manager.readthedocs.io/en/latest/) .yml file I used [cert-manager-no-webhook](https://github.com/jetstack/cert-manager/blob/master/deploy/manifests/cert-manager-no-webhook.yaml)  file generated automatically on github based on official helm chart
* Check what means when ‘webhook’ is enabled?
* Because of strict [rate-limits](https://letsencrypt.org/docs/rate-limits/) we will start with the Let’s Encrypt **staging** issuer.
* For example prod limits are 5 failures per hostname per hour (prod is 60 failures per hostname per hour) 

1. `k apply -f issuer/` you can apply multiple issuers to be ready
2. Make sure the IAM user with that access/secret key combination has this specific JSON [policy](http://docs.cert-manager.io/en/latest/reference/issuers/acme/dns01/route53.html)
3. Create secret_key file with secret key for accessing AWS resources; than: `k create secret generic route53 --from-file=secret_key -n cert-manager` … (or use ./create_secrets.sh script)
4. `k apply -f cert-manager.yml` or with helm you can:  `helm install --name cert-manager --namespace cert-manager stable/cert-manager`
5. Create ingress resources that supports TLS
6. There are two primary ways to do TLS termination in ingress: 
	1. Add [ingress-shim](https://cert-manager.readthedocs.io/en/latest/reference/ingress-shim.html#how-it-works) annotations to each ingress. Then we need only ClusterIssuer resource without Certificate resources ✅
	2. Other way is creating Certificate resources in same namespace as ingress
7. When you create cert-manager pod it will watch all ingresses annotations if some of them needs new TLS secret to be created. [1st way 👆]
8. Wait few minutes (5+) for certificates to be ready. (look at events with `-w` in certificate namespace) or read logs of cert-manager
9. As a conclusion we need ‘kubernetes.io/tls' secret per TLS ingress and per different issuer (staging/prod)
10. PS. (maybe you will need to refresh Ingress for triggering cert-manager)

## Changing TLS key for ingress / Change issuer for creation of new one
* In ingress resource change `tls.secretName` 
* If there is no key in kubernetes secrets then new one will be created by the cert-manager using the issuer **defined in certmanager.k8s.io/cluster-issuer SHIM annotation** ⚠️

## Using Traefik as Ingress Controller with TLS termination
* `k create configmap traefik-conf --from-file=ingress-controller-traefik/deployment_tls_ready/traefik.toml -n traefik` if you want to include .toml into traefik pod ⚠️
* Use `ingress-controller-traefik/deployment_tls_ready` manifests
* Consider “RollingUpdate” when using traefik DaemonSet

## Setting basic auth for ingress
* `sudo yum install httpd-tools`
* `htpasswd -c ./basic_auth aracki`
* `k create secret generic traefik-ui-basic-auth --from-file basic_auth -n traefik`
* `rm basic_auth`
* Add proper annotations to ingress resource
