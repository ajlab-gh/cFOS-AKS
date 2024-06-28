#!/bin/bash
#

IPADDRESS=$(kubectl -n dvwa get svc dvwa -o json | jq -r ".spec.clusterIP")

JSONDATA=$(kubectl -n fos get configmaps fosconfigvip-template -o json | jq '{data,apiVersion,kind}')

#echo $JSONDATA | yq -P | sed -e "VAR_DVWA_CLUSTER_IP,${IPADDRESS},g"
YAMLDATA=$(echo $JSONDATA | yq -P | sed -e s/VAR_DVWA_CLUSTER_IP/${IPADDRESS}/g)

cat <<EOF > manifest.yaml
---
metadata:
  labels:
    app: fos
    category: config
  name: dvwa-vip
  namespace: fos
$YAMLDATA
EOF
kubectl apply -f manifest.yaml
