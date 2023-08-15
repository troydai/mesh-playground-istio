export CTX_EXTERNAL_CLUSTER=kind-control
export CTX_REMOTE_CLUSTER=kind-remote
export REMOTE_CLUSTER_NAME=kind-remote-cluster

# Use IP for control cluster's API server, get the control cluster's API server IP
export EXTERNAL_ISTIOD_ADDR=$(kubectl -n istio-system --context="${CTX_EXTERNAL_CLUSTER}" get svc istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export SSL_SECRET_NAME=NONE