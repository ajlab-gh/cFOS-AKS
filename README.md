# cFOS-AKS

A Demo of Container FortiOS (cFOS) solution deployed into AKS.

```bash
git add . && git commit -m "fix: update the fqdn" &&  git switch -C robin "dev" && git push && gh pr create -a @me -B dev -t "fixing tags" -b "fixing tags" && gh pr merge -m -d && kubectl apply --kustomize manifests/
kubectl -n fos get configmaps fosconfigvip-template -o json | jq -r ".data.config"
kubectl -n dvwa get svc dvwa -o json | jq -r ".spec.clusterIP"
```
