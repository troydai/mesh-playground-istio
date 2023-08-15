#!/bin/bash

# Set up istio in remote cluster (client cluster)

source ./common.sh

cat <<EOF > crd/remote-config-cluster.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  namespace: external-istiod
spec:
  profile: remote
  values:
    global:
      istioNamespace: external-istiod
      configCluster: true
    pilot:
      configMap: true
    istiodRemote:
      injectionURL: https://${EXTERNAL_ISTIOD_ADDR}:15017/inject/cluster/${REMOTE_CLUSTER_NAME}/net/network1
    base:
      validationURL: https://${EXTERNAL_ISTIOD_ADDR}:15017/validate
EOF

sed  -i'.bk' \
  -e "s|injectionURL: https://${EXTERNAL_ISTIOD_ADDR}:15017|injectionPath: |" \
  -e "/istioNamespace:/a\\
      remotePilotAddress: ${EXTERNAL_ISTIOD_ADDR}" \
  -e '/base:/,+1d' \
  crd/remote-config-cluster.yaml; rm crd/remote-config-cluster.yaml.bk

istioctl manifest generate -f crd/remote-config-cluster.yaml --set values.defaultRevision=default > crd/remote-istio-manifest.yaml
kubectl create namespace external-istiod --context="${CTX_REMOTE_CLUSTER}"
kubectl apply --context="${CTX_REMOTE_CLUSTER}" -f crd/remote-istio-manifest.yaml
kubectl get mutatingwebhookconfiguration --context="${CTX_REMOTE_CLUSTER}"
kubectl get validatingwebhookconfiguration --context="${CTX_REMOTE_CLUSTER}"
