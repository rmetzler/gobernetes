# Keel
* [Keel](https://github.com/keel-hq/keel) is a tool for automated Kubernetes deployments
* Redeploy with: `curl --header "Content-Type: application/json" --request POST --data '{"name":"aracki/go-web-server", "tag":"0.0.10"}' https://example.com:30443/v1/webhooks/native --insecure`
* It works with `keel.sh/policy: all` in **go-ws.yml**. 
* Switching from version to version made easily.