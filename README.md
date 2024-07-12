# cFOS-AKS

A demo of Fortinet in a kubernetes environment with AI workload protection.

## Deploy Infrastructure

```bash
cd terraform
terraform init
terraform apply
terraform destroy
```

## Contributing

```bash
git add . && git commit -m "fix: update the fqdn" &&  git switch -C feat01 "dev" && git push && gh pr create -a @me -B dev -t "feat: adding new feature" -b "fixing tags" && gh pr merge -m -d
kubectl apply --kustomize manifests/
```

## AI Tools in VsCode

```bash
IPADDRESS=$(kubectl get svc -n ollama -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')
sudo sh -c "echo \"${IPADDRESS} www.bankexample.com\" >> /etc/hosts"
export OLLAMA_HOST="${IPADDRESS}:11434"
```

```bash
ollama list
```
