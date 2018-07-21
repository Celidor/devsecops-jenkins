# DevSecOps-Jenkins

Build a Jenkins server in AWS

First create the Jenkins AMI:

* Use Packer script in the jenkins-master-ami directory

Then build the Jenkins server using the ami

* Duplicate terraform.tfvars.example and rename to terraform.tfvars
* Enter details and save

The example below is for an environment name "csa1" and a domain "example.com"

```
terraform workspace new csa1
terraform plan
terraform apply
```
* Log in to Jenkins at: https://jenkins-csa1.example.com
* Copy the initial admin password from your terminal remote exec script
* Install suggested plugins
* Enter username and password

To destroy:
```
terraform destroy
```

Derived from: https://github.com/ignw/terraform-aws-jenkins
