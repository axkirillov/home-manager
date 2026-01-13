---
name: k8s-operator
description: Use when the user asks for Kubernetes cluster inspection and troubleshooting (kubectl + kustomize; non-destructive by default).
---

# K8s Operator Instructions

Use this skill when the user requests Kubernetes cluster inspection, troubleshooting, or operational guidance (pods/deployments/jobs/services/ingress, rollout issues, networking/DNS, resource pressure).

## K8s Mode Alignment

- All `kubectl` commands should be executed directly.
- Before running any `kubectl` commands, set `KUBECONFIG` to the kubeconfig path:

```shell
export KUBECONFIG=$HOME/.kube/jq-prod-shop-primary
```

- Use the `jq-shop-production` namespace by default (override only if the user specifies a different namespace).

## Operating Principles

- Default to **read-only** actions.
- Avoid destructive changes (`delete`, `drain`, `cordon`, `scale to 0`, `rollout undo`, `patch` that changes behavior) unless the user **explicitly asks**.
- Prefer scoping with `-n <namespace>` and label selectors to reduce noise.
- Always capture:
  - **context/cluster** and **namespace**
  - exact **resource names**
  - relevant **time window**

## Checklist / Runbook Flow

1. Identify scope
   - Confirm kubecontext and namespace.
   - Identify the affected workload/service name, symptoms, and when it started.

2. Establish cluster baseline (read-only)
   - Verify connectivity and basic health.

3. Triage the impacted workload
   - Inspect rollout status, pods, events, and logs.

4. Classify the failure mode
   - CrashLoopBackOff, ImagePullBackOff, Pending/Scheduling, readiness/liveness, networking/DNS, resource pressure, RBAC.

5. Recommend remediation (non-destructive first)
   - Configuration corrections, resource requests/limits, probes, image/registry access, service selectors, ingress rules.

6. If changes are requested: apply safely
   - Use `kubectl apply` for manifests, or `kubectl apply -k` for kustomize.
   - Prefer reversible changes and keep a record of what was changed.

7. Verify outcome
   - Confirm readiness, rollouts, endpoints, and user-level checks.

## Command Templates

### 0) Context & Namespace

```bash
kubectl config get-contexts
kubectl config current-context
kubectl get ns
```

Set a namespace for a session (optional):

```bash
NS=jq-shop-production
```

### 1) Baseline / Quick Triage

```bash
kubectl get nodes -o wide
kubectl get pods -A --sort-by=.status.startTime | tail -n 50
kubectl get events -A --sort-by=.metadata.creationTimestamp | tail -n 50
```

### 2) Workload Triage (Deployment)

```bash
kubectl -n "$NS" get deploy,rs,pods -o wide
kubectl -n "$NS" describe deploy <deployment>
kubectl -n "$NS" rollout status deploy/<deployment>
kubectl -n "$NS" get pods -l app=<label> -o wide
kubectl -n "$NS" describe pod <pod>
```

Logs:

```bash
kubectl -n "$NS" logs <pod> --all-containers=true --tail=200
kubectl -n "$NS" logs <pod> -c <container> --since=30m
kubectl -n "$NS" logs <pod> -p -c <container> --since=30m   # previous container (CrashLoop)
```

### 3) Failure Mode: ImagePullBackOff / ErrImagePull

```bash
kubectl -n "$NS" describe pod <pod> | sed -n '/Events:/,$p'
```

Focus on:
- image name/tag
- imagePullSecrets
- registry reachability
- auth errors

### 4) Failure Mode: Pending / Scheduling

```bash
kubectl -n "$NS" describe pod <pod>
kubectl get nodes -o wide
kubectl describe node <node>
```

If metrics-server exists:

```bash
kubectl top nodes
kubectl -n "$NS" top pods
```

### 5) Services / Endpoints

```bash
kubectl -n "$NS" get svc,endpoints,endpointslice -o wide
kubectl -n "$NS" describe svc <service>
kubectl -n "$NS" get pods -l <selector> -o wide
```

### 6) Ingress

```bash
kubectl -n "$NS" get ingress -o wide
kubectl -n "$NS" describe ingress <ingress>
```

Controller-specific (examples):

```bash
kubectl -n ingress-nginx get pods -o wide
kubectl -n ingress-nginx logs deploy/ingress-nginx-controller --tail=200
```

### 7) DNS / Networking (Debug Pod)

Create a temporary debug pod (only if user agrees):

```bash
kubectl -n "$NS" run net-debug --rm -it --image=ghcr.io/nicolaka/netshoot -- sh
```

Inside:

```sh
nslookup kubernetes.default
curl -vk http://<service>.<ns>.svc.cluster.local
```

### 8) Apply Changes (only when requested)

Apply raw manifests:

```bash
kubectl -n "$NS" apply -f ./path/to/manifests
```

Apply kustomize overlay:

```bash
kubectl -n "$NS" apply -k ./path/to/overlay
```

Watch rollout:

```bash
kubectl -n "$NS" rollout status deploy/<deployment>
```

## Common Issues

- Wrong namespace/context: confirm `kubectl config current-context` and use `-n` explicitly.
- Empty Endpoints: service selector mismatch or pods not Ready; compare `kubectl describe svc` selectors with pod labels.
- CrashLoopBackOff: check `kubectl logs -p` and pod `Events`; review probes, config, secrets, and exit codes.
- Image pull failures: check registry auth, `imagePullSecrets`, and image tag existence.
- Pending pods: look for `Insufficient cpu/memory`, taints/tolerations, node selectors, or quota constraints.
- RBAC forbidden: check service account bindings and the exact verb/resource in the error.
- DNS issues: verify CoreDNS pods health and test resolution from a debug pod.
