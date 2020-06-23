#!/bin/sh
echo "Creating backups"
cp -f udacity-c3-deployment/k8s/aws-secret.yaml udacity-c3-deployment/k8s/aws-secret.yaml.backup
cp -f udacity-c3-deployment/k8s/env-secret.yaml udacity-c3-deployment/k8s/env-secret.yaml.backup
cp -f udacity-c3-deployment/k8s/env-configmap.yaml udacity-c3-deployment/k8s/env-configmap.yaml.backup

echo "Setting up files"
 sed -i '' -e "s/___INSERT_AWS_CREDENTIALS_FILE__BASE64____/${AWS_CREDENTIALS}/g" udacity-c3-deployment/k8s/aws-secret.yaml
 sed -i '' -e "s/___INSERT_POSTGRES_USERNAME__BASE64___/${POSTGRES_USERNAME}/g" udacity-c3-deployment/k8s/env-secret.yaml
 sed -i '' -e "s/___INSERT_POSTGRES_PASSWORD__BASE64___/${POSTGRES_PASSWORD}/g" udacity-c3-deployment/k8s/env-secret.yaml
 sed -i '' -e "s/___INSERT_AWS_BUCKET___/${AWS_BUCKET}/g" udacity-c3-deployment/k8s/env-configmap.yaml
 sed -i '' -e "s/___INSERT_AWS_PROFILE___/${AWS_PROFILE}/g" udacity-c3-deployment/k8s/env-configmap.yaml
 sed -i '' -e "s/___INSERT_AWS_REGION___/${AWS_REGION}/g" udacity-c3-deployment/k8s/env-configmap.yaml
 sed -i '' -e "s/___INSERT_JWT_SECRET___/${JWT_SECRET}/g" udacity-c3-deployment/k8s/env-configmap.yaml
 sed -i '' -e "s/___INSERT_POSTGRES_DB___/${POSTGRES_DB}/g" udacity-c3-deployment/k8s/env-configmap.yaml
 sed -i '' -e "s/___INSERT_POSTGRES_HOST___/${POSTGRES_HOST}/g" udacity-c3-deployment/k8s/env-configmap.yaml

echo "Deploying secrets"
kubectl delete secret env-secret
kubectl create -f udacity-c3-deployment/k8s/env-secret.yaml
kubectl delete secret aws-secret
kubectl create -f udacity-c3-deployment/k8s/aws-secret.yaml
echo "Deploying env"
kubectl delete configmap env-config 
kubectl create -f udacity-c3-deployment/k8s/env-configmap.yaml
echo "Deploying feed"
kubectl apply -f udacity-c3-deployment/k8s/backend-feed-deployment.yaml
kubectl apply -f udacity-c3-deployment/k8s/backend-feed-service.yaml
echo "Deploying user"
kubectl apply -f udacity-c3-deployment/k8s/backend-user-deployment.yaml
kubectl apply -f udacity-c3-deployment/k8s/backend-user-service.yaml
echo "Deploying reverseproxy"
kubectl apply -f udacity-c3-deployment/k8s/reverseproxy-deployment.yaml
kubectl apply -f udacity-c3-deployment/k8s/reverseproxy-service.yaml
echo "Deploying frontend"
kubectl apply -f udacity-c3-deployment/k8s/frontend-deployment.yaml
kubectl apply -f udacity-c3-deployment/k8s/frontend-service.yaml

echo "Cleaning up"
mv -f udacity-c3-deployment/k8s/aws-secret.yaml.backup udacity-c3-deployment/k8s/aws-secret.yaml
mv -f udacity-c3-deployment/k8s/env-secret.yaml.backup udacity-c3-deployment/k8s/env-secret.yaml
mv -f udacity-c3-deployment/k8s/env-configmap.yaml.backup udacity-c3-deployment/k8s/env-configmap.yaml