#!/bin/bash

## install gcloud 
sudo apt-get install  -y apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install -y google-cloud-cli
gcloud version

## install docker
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

## install kubectl and configuring permissions for GKE cluster
sudo apt-get install kubectl
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
gcloud container clusters get-credentials private-cluster --location asia-east1-a --project menna-402718

## authentication for artifact registry
sudo gcloud auth print-access-token | sudo docker login -u oauth2accesstoken --password-stdin  us-central1-docker.pkg.dev

## pull the mongodb image from dockerhub ,rename and push again to artifact registry
sudo docker pull mongo
sudo docker tag mongo us-central1-docker.pkg.dev/menna-402718/project-images/mongo
sudo docker push us-central1-docker.pkg.dev/menna-402718/project-images/mongo

## clone my repo to deploy the mongodb 
sudo git clone https://github.com/mennahasan7/GCP-project
cd mongodb
sudo kubectl apply -f storage-class.yaml
sudo kubectl apply -f mongo-statefulset.yaml
sudo kubectl apply -f headless-service.yaml
cd

## initialise the mongodb replication set
sudo kubectl exec -it mongo-0 - mongosh
rs.initiate(
 {
 _id: "rs0",
 members: [
 { _id: 0, host: "mongodb-0.mongodb:27017" },
 { _id: 1, host: "mongodb-1.mongodb:27017" },
 { _id: 2, host: "mongodb-2.mongodb:27017" },
]
})
exit

## build the app image and push to artifact registry
cd nodejs
sudo docker bulid -t us-central1-docker.pkg.dev/menna-402718/project-images/nodejsapp
sudo docker push us-central1-docker.pkg.dev/menna-402718/project-images/nodejsapp

## deploy the app
sudo kubectl apply -f deployment.yaml
sudo kubectl apply -f loadbalancer.yaml
cd