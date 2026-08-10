You are diagnosing a sanitized Kubernetes incident. The pod `payments-api-7b8d9` in namespace `payments` is in
CrashLoopBackOff. Its last termination reason is `OOMKilled` with exit code 137. The container requests 256Mi and is
limited to 256Mi. Metrics immediately before termination show a 410Mi working set. The Deployment has three replicas
and no HPA.

Explain the evidence, identify the root cause, and return a minimal strategic merge patch that raises the request to
384Mi and limit to 512Mi. Do not propose removing the limit. Include verification and rollback commands, but do not
claim that you executed them.
