# EKS CLUSTER

This project will build EKS cluster in AWS including all the dependencies
To create the cluster you will need the following
1) Terraform
2) Kubectl (you will need version 1.22 for this setup the version need to match eks-cluster.tf version)
3) AWSCli

Follow this steps:
1) Clone the project folder in your environment
2) run terraform init
3) run aws configure (target to the AWS account you want to create the cluster on)
4) Validate that the default region in the provider.tf file is the region you want (default is us-east-1)
5) Make sure that the keypair mentioned in eks-node-group.tf file exist on your account default is qa-key
6) Validate that the VPC CIDR are not already in use by another VPC.
7) Execute terraform apply --auto-approve
8) Execute kubectl create -f complete-demo.yaml
9) Execute kubectl apply -f evolven-role-user.yaml
10) To get the service account token run:
    kubectl get secret $(kubectl get sa evolven-collector -n kube-system -o jsonpath='{.secrets[0].name}') -n kube-system  -o jsonpath='{.data.token}' | base64 --decode



