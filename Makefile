.PHONY: setup teardown

CONTROL_CLUSTER_NAME=control
REMOTE_CLUSTER_NAME=remote

setup:
	@ kind create cluster --config config/kind/primary.yml -n $(CONTROL_CLUSTER_NAME)
	@ kubectl apply -f config/kind/metallb-native.yaml --context $(CONTROL_CLUSTER_NAME)
	@ kubectl wait \
		--namespace metallb-system \
   		--for=condition=ready pod \
       	--selector=app=metallb \
       	--timeout=90s \
		--context $(CONTROL_CLUSTER_NAME)
	@ kubectl apply -f config/kind/metallb-config.yaml --context $(CONTROL_CLUSTER_NAME)
	@ kind create cluster --config config/kind/primary.yml -n $(REMOTE_CLUSTER_NAME)
	@ kubectl apply -f config/kind/metallb-native.yaml --context $(CONTROL_CLUSTER_NAME)
	@ kubectl wait \
		--namespace metallb-system \
   		--for=condition=ready pod \
       	--selector=app=metallb \
       	--timeout=90s \
		--context $(CONTROL_CLUSTER_NAME)
	@ kubectl apply -f config/kind/metallb-config.yaml --context $(CONTROL_CLUSTER_NAME)
	# @ istioctl install -y --verify
	# @ kubectl apply -f mesh/workloads.yml
	# @ kubectl apply -f mesh/gateway.yml

teardown:
	# @ kind delete cluster -n $(CLUSTER_NAME)
	@ kind delete cluster -A
