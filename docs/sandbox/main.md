# Terraform for Toto on an AWS Sandbox

This guide assumes the following Sandbox constraints: 
* Admin User is **not authorized to create IAM Users**.

Other than that, the admin user should be able to do everything an account owner can. 

## What's not in Terraform

The Configuration of a Toto environment is **not all done in Terraform**. Some things are still done **manually**. Those things are: 
* **Buying a domain** on Route53. *Do that yourself, manually*. 
* **Requesting a public certificate** to be issued for domains on AWS. 
* **Creation of subdomains and attachment to ALB**. 
* **Creating a Github Connection** to be used for the CI/CD CodePipeline and CodeBuild.
* **Creation of an S3 Bucket for Terraform**. 

**MAKE SURE YOU PERFORM THE BELOW PRELIMINARY WORK**. 

## Preliminary work: 

Follow the [Preliminary Work Instructions to prepare Terraform on an AWS Sandbox](preliminary.md) before anything else.

**IMPORTANT**: 
* Terraform runs from an EC2 instance. **YOU WILL NEED 2 INSTANCES**: one for dev and one for prod. <br>
That is made to avoid having to rerun `terraform init` everytime and risk messing up with ENV vars.

## Terraform
Terraform for Toto on an AWS Sandbox will create the following resources: 

* **Base** infrastructure resources (not specific to a Toto Microservice)
    * VPC Creation
    * Subnets creation (both for components like ALB and for the microservices)
    * Internet Gateway
    * Application Load Balancer 
* **ECS-specific** resources, for deployments on ECS
    * ECS Cluster
* **Microservice-specific** resources.
    * Target Groups for ALB
    * ECS Task Definition
    * ECS Service
    * ECR Repo
    * CI/CD pipeline with CodeBuild and CodePipeline

The first two (Base and ECS-specific) are taken care by the generic terraform files in the root of this project (ecs.tf, load-balancer.tf, networking.tf, etc...). 

The **Microservice-specific resources** instead must be created by a service-specific Terraform file, that will be named after the Microservice. <br>
E.g. a microservice called `toto-ms-pippo` will have a file called `toto-ms-pippo.tf` in this project, that takes care of creating task definition, service, ECR repo, etc... 


### Backend Configuration
Notes: 
* Terraform State will be saved in S3
* Terraform commands will be **run from within an EC2 Instance**. <br> 
The EC2 Instance **must have an IAM Role** attached that allows it to do what's needed (you can always check [Preliminary work](#preliminary-work)).<br>
This is why the `backend.tf` file **does not contain any AWS Keys**.


### Running Terraform
Make sure that you have 
* **Cloned this repo**
* Run the `scripts/<env>.sh` script that sets the TF_VARS
* Run `terraform init` on this VM (should only be done once in the lifetime of the VM - but not sure what happens if you need to use another VM at some point). <br>
To run the init, you need to specify the right terraform file: 
```
terraform init -backend-config=backend-dev.hcl
```

## Post Run
**IMPORTANT**!!

After Terraform has run, you'll have a **Load Balancer** and can now go to *Route 53* and **create a record that link to the ALB**. To do that, [follow this tutorial](https://github.com/nicolasances/aws-notes/blob/main/docs/own-domain-name-alb.md). <br>
This obviously has only to be done once.