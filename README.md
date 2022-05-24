# Assignment 1 deployment example
## Description

This deployment example will deploy an example app which has a service, service account, HPA and PDB associated with it all generated via Terraform.

## How to use it?
Prerequisite: please make sure you are using Minikube.
## Add local variable to map to Minikube port for deployment rather than hard coding it


1. Update backend.tf with your account's S3 bucket name, role name etc.
2. Update tfvars file with your EKS cluster details.
4. run below commands to deploy the example app:
    ```
    terraform init
    terraform plan -var-file="test-cluster.tfvars"
    terraform apply -var-file="test-cluster.tfvars"
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

IF logic for wether you want local terraform or S3
Makefile with make targets running via docker compose
stage in pipeline which utilises kube-bench
helm chart installation for metric server? Test
