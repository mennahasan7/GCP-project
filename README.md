# GCP-project
This repo contains the infrastructure as a code of the needed environment to  deploy a simple Node.js web application (stateless) that interacts with a highly available MongoDB (stateful) replicated across 3 zones and consisting of 1 primary and 2 secondaries on the GKE ,alongside some other files like deployment and dockerfile and the application ..
![project](https://github.com/mennahasan7/GCP-project/assets/140804803/d206bce9-57a2-48c8-a93c-4fafbd9fd539)

# Technologies:

    -NodeJS Express
    -MongoDB
    -Docker
    -Google Cloud Platform
    -Kubernetes

# Running the project:

    Clone the repo

        -adjust files for your own project
   
    Build infrastructure on GCP

        -terraform init
        -terraform apply

    Connect to private GKE cluster through private vm    

        -gcloud compute ssh management-instance --zone <your-zone> --project <your-project-id>

    Follow the example and execute the commands   
        
    Get the load balancer IP    

        -kubectl get svc

    Access from your browser at <loadbalancer-IP>:3000    

# Example of the built resources    
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/cea6a1af-cfbc-40e1-ae5a-9dc5134be5d2)

    the vpc with all the resources
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/8ac559ff-f6ee-4a05-ac76-e729e4cd3d97)

    both management and workload subnets
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/76914fc4-41bb-4d92-9c3c-87d749450295)

    the artifact registry to store the images
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/9de815a6-434b-42ee-b882-80b04a9e1f21)

    The private cluster where we will deploy the app
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/5aa67687-ca3f-4f9b-be77-ce43d1de2a0c)

    The private vm 
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/f445e80a-dff5-4929-aacb-f3a07b2581a5)

    The service accounts for vm and cluster
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/86edca92-5c19-4ac8-b3b2-977f21ad8989)
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/1383beb6-84d9-47b7-917b-8cbbf383d37e)

    The firewall that allow ssh through IAP tunnel
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/7da71212-36c1-4a67-ab98-12a74de0f996)

    The natgateway for management subnet
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/0ac02474-5e8e-4e12-8d87-a19681698a05)

    connection the VM the one inside the management subnet with the cluster to be able to deploy the app 
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/dbcee895-02e5-4b07-8450-f36354d55937)

    commands to run
    
        ## clone my repo to deploy the mongodb and the nodejs app 
        sudo git clone https://github.com/mennahasan7/GCP-project.git
        
        ## deploy the app
        cd GCP-project/mongodb
        kubectl apply -f storage-class.yaml
        kubectl apply -f mongo-statefulset.yaml
        kubectl apply -f headless-service.yaml
        ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/770b8ee0-7356-4809-bf0f-b5568e60c42f)
        ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/a82e844d-1580-47dd-b840-b77cbab24cb2)

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
        ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/36d426eb-4c8d-47b8-98eb-12a872d36acd)
        ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/4fbe465e-35d9-43df-b408-e4050a248e93)
        ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/eb56de0a-7c49-47a8-ae80-791027f6da47)
        ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/d6aabdac-19f6-4bde-bfad-4a25596c3cf3)

        ## build the app image and push to artifact registry
        cd GCP-project/nodejs
        sudo docker build -t us-central1-docker.pkg.dev/menna-402718/project-images/nodejsapp .
        sudo docker push us-central1-docker.pkg.dev/menna-402718/project-images/nodejsapp
        ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/baba1f30-fe23-45e8-b688-d596fca93975)

        ## deploy the app
        kubectl apply -f deployment.yaml
        kubectl apply -f loadbalancer.yaml
        ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/966816b5-73f1-4603-93f5-70643295a190)

    get the pods from the deployment
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/2a55ef54-eca8-42e4-8846-9575676767ac)

    from the load balancer use the Ip to be able to see the running app
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/b18a28cf-fe98-4413-b35d-e6ac3eae3242)
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/5fc2afa8-1560-4e1b-ba7c-15852adcbbcf)

    finally use the command "terraform destroy" to destroy all of the built resources

# Test the retainance of data
    
    deleting the primary pod 
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/db7b1b0c-2b02-41fa-ba2e-e18248948a49)

    election of another to be primary
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/395e72af-b00b-45bb-8279-875c39e53233)
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/efac5b00-b41e-4b23-8cc2-52eedb09b77e)
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/2935a97f-059e-4395-8a07-d55b6fb57a5f)

    data of visits retained 
    ![image](https://github.com/mennahasan7/GCP-project/assets/140804803/9580bcc0-7313-42d9-b933-de32df01c774)
