# terraform

```bash
kubectl -n store-dev exec --stdin --tty store-firewall-757b68495f-nkcwl -- /bin/cli
```

az extension add -n aks-preview
az extension update --name aks-preview

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
