#!/bin/bash

# Set up the istio-gateway for the control plane in the control cluster (external cluster)

source ./common.sh

CTRL_GW_CRD=crd/controlplane-gateway.yaml

cat <<EOF > "$CTRL_GW_CRD"
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  namespace: istio-system
spec:
  components:
    ingressGateways:
      - name: istio-ingressgateway
        enabled: true
        k8s:
          service:
            ports:
              - port: 15021
                targetPort: 15021
                name: status-port
              - port: 15012
                targetPort: 15012
                name: tls-xds
              - port: 15017
                targetPort: 15017
                name: tls-webhook
EOF

istioctl install -f "${CTRL_GW_CRD}" --context="${CTX_EXTERNAL_CLUSTER}" -y
