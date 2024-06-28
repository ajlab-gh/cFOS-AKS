# cFOS-AKS

A Demo of Container FortiOS (cFOS) solution deployed into AKS.

```bash
kubectl apply --kustomize manifests/
```

```bash
kubectl -n fos get configmaps fosconfigvip-template -o json | jq -r ".data.config"
kubectl -n dvwa get svc dvwa -o json | jq -r ".spec.clusterIP"
```
