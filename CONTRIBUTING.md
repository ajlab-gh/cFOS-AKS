# Contributing

```bash
git switch -C feat01 "dev"
oco
gh pr create -B dev -a @me --fill-verbose
gh pr merge -m -d
```

```bash
git switch -C feat01 "dev" && git add . && git commit -m "fix: updating config" && git push &&  gh pr create -B dev -a @me --fill-verbose &&  gh pr merge -m -d
```

```bash
kubectl apply --kustomize manifests/
```
