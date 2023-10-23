# GCP-project
This repo contains the infrastructure as a code of the needed environment to  deploy a simple Node.js web application (stateless) that interacts with a highly available MongoDB (stateful) replicated across 3 zones and consisting of 1 primary and 2 secondaries on the GKE ,alongside some other files like deployment and dockerfile and the application ..

# Technologies:

    -NodeJS Express
    -MongoDB
    -Docker
    -Google Cloud Platform
    -Kubernetes

# Running the project:

    Clone the repo

      adjust files for your own project
   
    Build infrastructure on GCP

        terraform init
        terraform apply

    Connect to private GKE cluster through private vm    

        gcloud compute ssh management-instance --zone <your-zone> --project <your-project-id>

    Follow the example and execute the commands   
        
    Get the load balancer IP    

        kubectl get svc

    Access from your browser at <loadbalancer-IP>:3000    

# Example of the built resources    

    the vpc with all the resources

    both management and restricted subnet

    the docker image that has been built and pushed to the GCR
    
    The private cluster where we will deploy the app

    The private vm 
   
    connection the VM the one inside the management subnet with the cluster to be able to deploy the app 

    commands to run
        ## deploy the app
        cd GCP-project
        cd mongodb
        kubectl apply -f storage-class.yaml
        kubectl apply -f mongo-statefulset.yaml
        kubectl apply -f headless-service.yaml
        cd ..

        ## initialise the mongodb replication set
        kubectl exec -it mongo-0 -- mongosh
        rs.initiate(
        {
        _id: "rs0",
        members: [
        { _id: 0, host: "mongo-0.mongo:27017" },
        { _id: 1, host: "mongo-1.mongo:27017" },
        { _id: 2, host: "mongo-2.mongo:27017" },
        ]
        })
        exit

        ## build the app image and push to artifact registry
        cd nodejs
        sudo docker build -t us-central1-docker.pkg.dev/menna-402718/project-images/nodejsapp .
        sudo docker push us-central1-docker.pkg.dev/menna-402718/project-images/nodejsapp

        ## deploy the app
        kubectl apply -f deployment.yaml
        kubectl apply -f loadbalancer.yaml
        cd ..

    get the pods from the deployment

    from the load balancer use the Ip to be able to see the running app

    finally use the command "terraform destroy" to destroy all of the built resources

# Test the retainance of data
    
    deleting the primary pod 
    election of another to be primary
    data of visits retained 