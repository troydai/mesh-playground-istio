#!/bin/bash

source ./common.sh

cat <<EOF > crd/external-istiod-gw.yaml
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: external-istiod-gw
  namespace: external-istiod
spec:
  selector:
    istio: ingressgateway
  servers:
    - port:
        number: 15012
        protocol: https
        name: https-XDS
      tls:
        mode: SIMPLE
        credentialName: $SSL_SECRET_NAME
      hosts:
      - $EXTERNAL_ISTIOD_ADDR
    - port:
        number: 15017
        protocol: https
        name: https-WEBHOOK
      tls:
        mode: SIMPLE
        credentialName: $SSL_SECRET_NAME
      hosts:
      - $EXTERNAL_ISTIOD_ADDR
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
   name: external-istiod-vs
   namespace: external-istiod
spec:
    hosts:
    - $EXTERNAL_ISTIOD_ADDR
    gateways:
    - external-istiod-gw
    http:
    - match:
      - port: 15012
      route:
      - destination:
          host: istiod.external-istiod.svc.cluster.local
          port:
            number: 15012
    - match:
      - port: 15017
      route:
      - destination:
          host: istiod.external-istiod.svc.cluster.local
          port:
            number: 443
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: external-istiod-dr
  namespace: external-istiod
spec:
  host: istiod.external-istiod.svc.cluster.local
  trafficPolicy:
    portLevelSettings:
    - port:
        number: 15012
      tls:
        mode: SIMPLE
      connectionPool:
        http:
          h2UpgradePolicy: UPGRADE
    - port:
        number: 443
      tls:
        mode: SIMPLE
EOF

sed  -i'.bk' \
  -e '55,$d' \
  -e 's/mode: SIMPLE/mode: PASSTHROUGH/' -e '/credentialName:/d' -e "s/${EXTERNAL_ISTIOD_ADDR}/\"*\"/" \
  -e 's/http:/tls:/' -e 's/https/tls/' -e '/route:/i\
        sniHosts:\
        - "*"' \
  crd/external-istiod-gw.yaml; rm crd/external-istiod-gw.yaml.bk

kubectl apply -f crd/external-istiod-gw.yaml --context="${CTX_EXTERNAL_CLUSTER}"
