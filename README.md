# cFOS-AKS

A Demo of Container FortiOS (cFOS) solution deployed into AKS.

```bash
git add . && git commit -m "fix: update the fqdn" &&  git switch -C robin "dev" && git push && gh pr create -a @me -B dev -t "fixing tags" -b "fixing tags" && gh pr merge -m -d && kubectl apply --kustomize manifests/
```

```bash
IPADDRESS=$(kubectl get svc -n ollama -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')
sudo sh -c "echo \"${IPADDRESS} www.bankexample.com\" >> /etc/hosts"
export OLLAMA_HOST="${IPADDRESS}:11434"
```
