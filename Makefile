.PHONY: setup teardown install-workloads uninstall-workloads

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
	@ istioctl install --skip-confirmation --verify --set values.pilot.env.ENABLE_NATIVE_SIDECARS=true
	@ kubectl apply -f mesh/workloads.yml
	@ kubectl apply -f mesh/gateway.yml

teardown:
	@ kind delete cluster -n $(CLUSTER_NAME)

install-workloads:
	@ kubectl create ns httpbin-red
	@ helm install -n httpbin-red httpbin-red charts/httpbin
	@ kubectl create ns httpbin-blue
	@ helm install -n httpbin-blue httpbin-blue charts/httpbin

uninstall-workloads:
	@ helm uninstall -n httpbin-red httpbin-red
	@ kubectl delete ns httpbin-red
	@ helm uninstall -n httpbin-blue httpbin-blue
	@ kubectl delete ns httpbin-blue
