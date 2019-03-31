# DevSecOps-Jenkins

Deploys a Jenkins server in AWS with the plugins and IAM role needed for Serverless Framework pipelines

## Build Jenkins Amazon Machine Image (AMI)

* Use Packer script in the jenkins-master-ami directory

## Requirements

* terraform 0.11.7
* aws CLI 1.15

## Build a Jenkins server in AWS

* clone the repository

```
git clone https://github.com/celidor/devsecops-jenkins
cd devsecops-jenkins
```

* Duplicate terraform.tfvars.example and rename to terraform.tfvars
* Enter details and save

The example below is for an environment name "csa1" and a domain "example.com"

* Log in to the AWS console, select EC2, Key Pairs
* Create a new key pair named jenkins-csa1 in region eu-west-1

```
terraform workspace new csa1
terraform plan
terraform apply
```
* Log in to Jenkins at: https://jenkins-csa1.example.com
* SSH into the Jenkins instance to obtain the initial admin password
* Install suggested plugins
* Enter username and password

To destroy:
```
terraform destroy
```

## IAM Policies

Deployment of this infrastructure has been tested by a user with these IAM policies:

* AmazonEC2FullAccess (AWS managed policy)
* https://github.com/Celidor/devsecops-jenkins/blob/master/iam/devsecops-jenkins.json
* https://github.com/Celidor/devsecops-jenkins/blob/master/iam/iam-self-service.json
* AmazonS3FullAccess (AWS managed policy)
* AmazonAPIGatewayAdministrator (AWS managed policy)
* AmazonAPIGatewayInvokeFullAccess (AWS managed policy)
* AWSLambdaReadOnlyAccess (AWS managed policy)


## Acknowledgement

This code has been derived from: https://github.com/ignw/terraform-aws-jenkins
