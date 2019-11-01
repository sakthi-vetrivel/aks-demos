# Reset
# Now to reset the in-person demo, run the following commands:
kubectl delete -f iis-svc-ingress.yaml
helm delete $(helm ls --short)
kubectl get nodes -l beta.kubernetes.io/os=windows -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | xargs -I XX kubectl taint nodes XX windows:NoSchedule-
