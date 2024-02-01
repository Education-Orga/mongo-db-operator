#!/bin/bash

# set context to application-cluster
KUBE_CONTEXT="kind-application-cluster"
kubectl config use-context "$KUBE_CONTEXT"

# create mongodb  namespace if not present
MONGODB_NAMESPACE="mongodb"
kubectl get ns "$MONGODB_NAMESPACE" || kubectl create ns "$MONGODB_NAMESPACE"

# install OLM
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.26.0/install.sh | bash -s v0.26.0

# deploy mongodb operator from operatorhub manifests
echo "deploy mongodb operator..."
kubectl create -f https://operatorhub.io/install/mongodb-enterprise.yaml

# deploy mongodb crds
kubectl apply -f configs/mongodb-deployment.yaml -n "$MONGODB_NAMESPACE"
kubectl apply -f configs/mongodb-ops-manager.yaml -n "$MONGODB_NAMESPACE"
kubectl apply -f configs/mongodb-user.yaml -n "$MONGODB_NAMESPACE"

echo "MongoDB and CRDs deployed successfully in namespace '$MONGODB_NAMESPACE' of context '$KUBE_CONTEXT'."