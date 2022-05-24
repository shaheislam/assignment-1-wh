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
3. Start Minikube
    `minikube start`
4. Get port Minikube is running on
    `kubectl cluster-info`
5. Get port Minikube is running on
    `kubectl cluster-info`
6. Update .tfvars file with 'minikube_port' value
7. run below commands to deploy the example app & infrastructure:
    ```
    terraform init
    terraform plan
    terraform apply
    ```



5. Log into your cluster, you should be able to see two continers running in example-app pod:
    ```
    //Get pods in secrets-example namespace
    kubectl get pods -n secrets-example

    NAME                          READY   STATUS    RESTARTS   AGE
    example-app-6f45c68fc-4qkfm   2/2     Running   0          89s

    //List containers running in that pod
    kubectl get pod example-app-6f45c68fc-4qkfm -n secrets-example -o jsonpath='{.spec.containers[*].name}'

    http-echo vault-agent

    //Read vault secrets from example app pod
    k exec -it example-app-6f45c68fc-4qkfm -c http-echo -- cat vault/secrets/creds.yaml

    login:
        username: god
        password: S3cretPassw0rd!
    ```

## Related docs
https://docs.gitlab.com/ee/ci/examples/


MENTION
Prereqs, Docker
downloading https://hub.docker.com/r/nginxinc/nginx-unprivileged


## Future Improvements
1. Store terraform backend statefile for S3
2. AWS Secretsmanager / Vault Injection for securely storing secrets and injecting into K8s at runtime without exposing as is current state. (Have experience with both of these methods)
3. Additional Github actions
4. Run backend provider for different regions through local rendering of values within Terraform
