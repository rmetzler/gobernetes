#!/bin/bash

# ALERT MANAGER SLACK RECEIVER recreation
kubectl delete -n monitoring secret alertmanager-main
kubectl create -n monitoring secret generic alertmanager-main --from-file=secrets/alertmanager.yaml

# ROUTE53 ACCESS
kubectl create -n cert-manager secret generic route53 --from-file=secrets/secret_key

# GRAFANA AUTHENTICATION
kubectl create -n monitoring secret generic grafana-auth --from-file=secrets/grafana-auth

# TRAEFIK-UI BASIC AUTH
kubectl create -n traefik secret generic traefik-basic-auth --from-file=secrets/basic_auth

# WEAVE-SCOPE BASIC AUTH
kubectl create -n weave secret generic traefik-basic-auth --from-file=secrets/basic_auth

