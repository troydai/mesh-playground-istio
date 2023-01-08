.PHONY: setup teardown

CLUSTER_NAME=mesh-playground-istio

setup:
	@ kind create cluster --config config/kind/kind-config.yml -n $(CLUSTER_NAME)

teardown:
	@ kind delete cluster -n $(CLUSTER_NAME)