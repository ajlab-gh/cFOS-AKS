#!/bin/bash
#

IPADDRESS=$(kubectl -n ollama get svc ollama -o json | jq -r ".spec.clusterIP");
CONFIGDATA=$(kubectl -n fos get configmaps fos-vip-template -o json | jq -r ".data.config" | sed -e s/VAR_CLUSTER_IP/${IPADDRESS}/g | sed -e s/VAR_APP_NAME/ollama/g | sed 's/^/    /');
echo -e "---\nmetadata:\n  labels:\n    app: fos\n    category: config\n  name: ollama\n  namespace: fos\ndata:\n  config: |\n$CONFIGDATA\ntype: partial\napiVersion: v1\nkind: ConfigMap"
