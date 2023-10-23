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
![Screenshot from 2023-10-23 19-08-24](https://github.com/mennahasan7/GCP-project/assets/140804803/2892b868-32ee-453b-a0d6-09acb5bf1e22)

    the vpc with all the resources
![Screenshot from 2023-10-23 19-15-04](https://github.com/mennahasan7/GCP-project/assets/140804803/852be2c0-4f1e-486e-b5d4-9d5d1c6c12c3)

    both management and workload subnets
![Screenshot from 2023-10-23 19-16-22](https://github.com/mennahasan7/GCP-project/assets/140804803/2714ab9f-60de-473d-8938-45af360cfcb7)

    the artifact registry to store the images
![Screenshot from 2023-10-23 19-18-03](https://github.com/mennahasan7/GCP-project/assets/140804803/a75b7d4a-ad2f-4f9f-9ef6-ad645d1cf5f0)

    The private cluster where we will deploy the app
![Screenshot from 2023-10-23 19-18-55](https://github.com/mennahasan7/GCP-project/assets/140804803/ba56cd90-8d6b-494a-bf66-ee203c40cdde)

    The service accounts for vm and cluster
![Screenshot from 2023-10-23 19-21-35](https://github.com/mennahasan7/GCP-project/assets/140804803/26eb1935-f568-413c-9f35-e6149c39a07d)
![Screenshot from 2023-10-23 19-22-07](https://github.com/mennahasan7/GCP-project/assets/140804803/d58b3210-5870-4579-9dc1-23b5632856ff)

    connection the VM the one inside the management subnet with the cluster to be able to deploy the app 
![Screenshot from 2023-10-23 19-31-06](https://github.com/mennahasan7/GCP-project/assets/140804803/703f4ec2-ad67-44b0-a8f2-96131e13ef7f)

    commands to run
    
        ## clone my repo to deploy the mongodb and the nodejs app 
        sudo git clone https://github.com/mennahasan7/GCP-project.git
        
        ## deploy the app
        cd GCP-project/mongodb
        kubectl apply -f storage-class.yaml
        kubectl apply -f mongo-statefulset.yaml
        kubectl apply -f headless-service.yaml
![Screenshot from 2023-10-23 19-38-52](https://github.com/mennahasan7/GCP-project/assets/140804803/3e767ad7-5af3-47d7-a0be-b4f8d759465c)
![Screenshot from 2023-10-23 19-40-08](https://github.com/mennahasan7/GCP-project/assets/140804803/6fe4917d-3a72-4938-8413-1969b818a950)

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
![Screenshot from 2023-10-23 19-42-16](https://github.com/mennahasan7/GCP-project/assets/140804803/da88f2fd-b4e5-4078-a62c-8e026f8ff86a)
![Screenshot from 2023-10-23 19-43-10](https://github.com/mennahasan7/GCP-project/assets/140804803/51d1d22d-ad22-4003-a482-6fcd9e3182d8)
![Screenshot from 2023-10-23 19-43-33](https://github.com/mennahasan7/GCP-project/assets/140804803/0493aa85-0fe9-4241-83df-7101fb515d3a)
![Screenshot from 2023-10-23 19-43-56](https://github.com/mennahasan7/GCP-project/assets/140804803/f3138672-268d-4a64-aef7-8bef33d03387)

        ## build the app image and push to artifact registry
        cd GCP-project/nodejs
        sudo docker build -t us-central1-docker.pkg.dev/menna-402718/project-images/nodejsapp .
        sudo docker push us-central1-docker.pkg.dev/menna-402718/project-images/nodejsapp
![Screenshot from 2023-10-23 19-49-55](https://github.com/mennahasan7/GCP-project/assets/140804803/30e35e4b-72d7-41a6-bab1-5f70e782f327)

        ## deploy the app
        kubectl apply -f deployment.yaml
        kubectl apply -f loadbalancer.yaml
![Screenshot from 2023-10-23 19-52-24](https://github.com/mennahasan7/GCP-project/assets/140804803/c96ca554-f074-4bdf-a3e8-91c2bd14f8d7)

    get the pods from the deployment
![Screenshot from 2023-10-23 19-53-07](https://github.com/mennahasan7/GCP-project/assets/140804803/b3a8711f-6041-45fd-94e4-0d260e40c744)

    from the load balancer use the Ip to be able to see the running app
![Screenshot from 2023-10-23 19-54-06](https://github.com/mennahasan7/GCP-project/assets/140804803/56d02012-9bcf-4894-a274-4bf0b5554774)
![Screenshot from 2023-10-23 19-55-33](https://github.com/mennahasan7/GCP-project/assets/140804803/92f64b81-61eb-47ad-a0e9-3b3f464937f2)

    finally use the command "terraform destroy" to destroy all of the built resources

# Test the retainance of data
    
    deleting the primary pod 
![Screenshot from 2023-10-23 19-59-03](https://github.com/mennahasan7/GCP-project/assets/140804803/5d76e112-6327-4775-8d02-9b5d2d26c0e4)

    election of another to be primary
![Screenshot from 2023-10-23 20-00-57](https://github.com/mennahasan7/GCP-project/assets/140804803/1b470bcb-2d43-4519-9ff5-2ce82c5cfdd4)
![Screenshot from 2023-10-23 20-01-24](https://github.com/mennahasan7/GCP-project/assets/140804803/a3da679e-7322-46a2-a967-ae6bb534e0c0)
![Screenshot from 2023-10-23 20-01-39](https://github.com/mennahasan7/GCP-project/assets/140804803/6fdcc56e-7be2-4f8b-945d-8d81ab67a8f0)

    data of visits retained 
![Screenshot from 2023-10-23 20-02-23](https://github.com/mennahasan7/GCP-project/assets/140804803/fd2ed576-09d9-4ae2-95a8-b8bf22a8781d)

