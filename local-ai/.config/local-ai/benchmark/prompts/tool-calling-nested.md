Investigate the `payments-api` OOM incident in namespace `payments` for pod `payments-api-7b8d9` using only the
supplied read-only tools. First obtain events for that pod, then obtain the `payments-api` Deployment manifest in
the same namespace, then submit a candidate patch to the dry-run validator. Never skip validation and never claim
that the patch was applied.
