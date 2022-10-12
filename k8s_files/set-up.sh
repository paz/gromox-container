#!/bin/bash

echo 'This script assumes that you have a working kubernetes cluster and the kubectl context is set to it'

kubectl apply -f db-config.yaml
kubectl apply -f ssl-config.yaml
kubectl apply -f redis-config.yaml
kubectl apply -f admin-config.yaml
kubectl apply -f admin-plugins-config.yaml
kubectl apply -f admin-links-config.yaml
kubectl apply -f redis.yaml
kubectl apply -f db.yaml
sleep 60s
kubectl apply -f init-db.yaml
sleep 90s
kubectl apply -f gromox.yaml
sleep 60s
helm repo add jitsi https://jitsi-contrib.github.io/jitsi-helm/
helm install gromox-meet jitsi/jitsi-meet -f video/video-values.yml
