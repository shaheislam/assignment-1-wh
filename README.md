# Assignment 1 deployment example
## Description

This deployment example will deploy an example app which has a service, service account, HPA and PDB associated with it all generated via Terraform. The API_KEY is set as an environment variable to validate this.

### Prerequisite:

- Minikube
- Docker
- Terraform


## How to use it?

1. Pull the repository to your local
    `git clone git@github.com:shaheislam/william-hill-1.git`
2. Start Docker
    `open -a Docker` - Mac
    `sudo service docker start` - Linux
3. Pull nginx image for use
    `docker pull nginxinc/nginx-unprivileged:1.20`
4. Start Minikube
    `minikube start`
5. Get port Minikube is running on
    `kubectl cluster-info`
6. Get port Minikube is running on
    `kubectl cluster-info`
7. Update .tfvars file with 'minikube_port' value
8. run below commands to deploy the example app & infrastructure:
    ```
    terraform init
    terraform plan -var-file="cluster.tfvars"
    terraform apply -var-file="cluster.tfvars"
    ```
9. Log into your cluster, you should be able to see one container running in example-app pod:
    ```
    //Get pods in example-app namespace
    kubectl get pods -n example-app

    NAME                           READY   STATUS    RESTARTS   AGE
    example-app-74476b68d5-9cbz5   1/1     Running   0          63m
    example-app-74476b68d5-pfzz6   1/1     Running   0          63m
    example-app-74476b68d5-rvpz9   1/1     Running   0          63m

    //List containers running in that pod
    kubectl get pod example-app-74476b68d5-9cbz5 -n example-app -o jsonpath='{.spec.containers[*].name}'

    nginx-app

    //Validate environment variable API_KEY exists within container
    kubectl exec example-app-74476b68d5-9cbz5 -c nginx-app -- printenv | grep API_KEY

    API_KEY=P4ssw0rd
    ```

## Related docs

https://docs.gitlab.com/ee/ci/examples/


## Future Improvements

1. Store terraform backend statefile for S3
2. AWS Secretsmanager / Vault Injection for securely storing secrets and injecting into K8s at runtime without exposing as is current state. (Have experience with both of these methods)
3. Additional Github actions
4. Run backend provider for different regions through local rendering of values within Terraform
