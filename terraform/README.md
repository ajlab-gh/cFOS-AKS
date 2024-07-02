# terraform

https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2?tabs=azure-cli

https://github.com/Azure/gitops-flux2-kustomize-helm-mt

https://github.com/fluxcd/flux2-kustomize-helm-example

```bash
kubectl logs --tail=200 -l app=fos -n fos
```

```bash
kubectl get events -n flux-system --field-selector type=Warning
```

```bash
kubectl -n store-dev exec --stdin --tty store-firewall-757b68495f-nkcwl -- /bin/cli
```

```bash
az extension add -n k8s-configuration
az extension add -n k8s-extension
az extension add -n aks-preview
az extension update -n k8s-configuration
az extension update -n k8s-extension
az extension update --name aks-preview
```

```bash
az feature register --namespace Microsoft.ContainerService --name AKS-GitOps
az feature register --namespace Microsoft.ContainerService --name AutomaticSKUPreview
az feature register --namespace Microsoft.ContainerService --name AzureServiceMeshPreview
az feature register --namespace Microsoft.ContainerService --name DisableSSHPreview
az feature register --namespace Microsoft.ContainerService --name EnableAPIServerVnetIntegrationPreview
az feature register --namespace Microsoft.ContainerService --name NetworkObservabilityPreview
az feature register --namespace Microsoft.ContainerService --name NodeAutoProvisioningPreview
az feature register --namespace Microsoft.ContainerService --name NRGLockdownPreview
az feature register --namespace Microsoft.ContainerService --name SafeguardsPreview

az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.KubernetesConfiguration

```
