#!/bin/bash

token=$(kubectl -n kubernetes-dashboard create token admin-user)

echo -n "$token" | pbcopy

echo "Token has be copied to the clipboard. Start dashboard at http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"

kubectl proxy
