# cFOS-AKS

A demo of Fortinet in a kubernetes environment with AI workload protection.

## Deploy Infrastructure

```bash
cd terraform
terraform init
terraform apply
terraform destroy
```

## AI Tools in VsCode

```bash
IPADDRESS=$(kubectl get svc -n ollama -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')
sudo sh -c "echo \"${IPADDRESS} www.bankexample.com\" >> /etc/hosts"
export OLLAMA_HOST="${IPADDRESS}:11434"

ollama list
```
