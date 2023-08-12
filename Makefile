.PHONY: setup teardown

CLUSTER_NAME=istio-playground

setup:
	@ kind create cluster --config config/kind/primary.yml -n $(CLUSTER_NAME)
	@ kubectl apply -f config/kind/metallb-native.yaml
	@ kubectl wait \
		--namespace metallb-system \
   		--for=condition=ready pod \
       	--selector=app=metallb \
       	--timeout=90s
	@ kubectl apply -f config/kind/metallb-config.yaml
	@ istioctl install -y --verify
	@ kubectl apply -f mesh/workloads.yml
	@ kubectl apply -f mesh/gateway.yml

teardown:
	@ kind delete cluster -n $(CLUSTER_NAME)
