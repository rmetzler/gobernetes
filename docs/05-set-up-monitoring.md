# Monitoring 
* Apply all manifests from [coreos/prometheus-operator/kube-prometheus](https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus#alertmanager-configuration) (this command sometimes may need to be done twice, to avoid race condition).
* Teardown the stack by deleting all manifests
* Components included:
	* The Prometheus Operator (coreos component)
	* Highly available Prometheus (x2)
	* Highly available Alertmanager (x3)
	* Prometheus node-exporter for each node
	* kube-state-metrics
	* Grafana
* Expose them through Ingresses:
	* For Prometheus/AlertManager put basic auth
	* Grafana has its own basic auth. Change admin password!
* ⚠️ Never delete a namespace. If so, secrets for basic auth and TLS will be deleted.
* Misc tools:
	* look at this [alertmanager.yaml](https://github.com/camilb/prometheus-kubernetes/blob/master/assets/alertmanager/alertmanager.yaml)
	* nice [grafana dashboard for aws costs](https://grafana.com/dashboards/6873)
	* [GitHub - kubernetes-monitoring/kubernetes-mixin: A set of Grafana dashboards and Prometheus alerts for Kubernetes.](https://github.com/kubernetes-monitoring/kubernetes-mixin)
	
## Slack notifications
* **SLACK** notifications:
	* Important Slack API links: [tokens](https://api.slack.com/tokens) & [legacy-tokens](https://api.slack.com/custom-integrations/legacy-tokens)
	* Test: `curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' https://hooks.slack.com/services/<hash>/<hash>/<hash>`
	* Encode with base64 .alert_secrey.yaml (git ignored file) and put it in alertmanager-secret.yaml
	* Make alertmanager secret with `./create-secrets.sh`

### Grafana
* Grafana stores dashboards in [grafana-dashboardDefinitions.yaml](https://github.com/Aracki/gobernetes/blob/master/k8s_manifests/monitoring/grafana-dashboardDefinitions.yaml)
* Beside that we can import default dashboards in Data Sources configuration:  `https://grafana.mydomain.com:30443/datasources/edit/1/dashboards`
* [Add new dashboard example](https://github.com/Aracki/gobernetes/commit/bab89c23410c0fc4ff00f36c5a7ea157f0a3e30d):
	* Add new config map in config map list
	* In grafana deployment yml file add new volume mountPath

### Alert manager
* [Fix CoreDNS Down](https://github.com/coreos/prometheus-operator/issues/2278) add metrics port  9153 to coreDNS service with `k edit svc -n kube-system kube-dns`
* Remove following alerts from prometheus-rules.yaml and ServiceMonitor:
	* KubeControllerManagerDown
	* KubeSchedulerDown
	* AlertmanagerMembersInconsistent