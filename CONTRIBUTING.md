## Contributing

```bash
git add . && git commit -m "fix: update the fqdn" &&  git switch -C feat01 "dev" && git push && gh pr create -a @me -B dev -t "feat: adding new feature" -b "fixing tags" && gh pr merge -m -d
```

```bash
kubectl apply --kustomize manifests/
```
