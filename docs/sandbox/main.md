# Terraform for Toto on an AWS Sandbox

This guide assumes the following Sandbox constraints: 
* Admin User is **not authorized to create IAM Users**.

Other than that, the admin user should be able to do everything an account owner can. 

## What's not in Terraform

The Configuration of a Toto environment is **not all done in Terraform**. Some things are still done **manually**. Those things are: 
* **Buying a domain** on Route53. 
* **Requesting a public certificate** to be issued for domains on AWS. 
* **Creation of subdomains and attachment to ALB**. 
* **Creating a Github Connection** to be used for the CI/CD CodePipeline and CodeBuild.
* **Creation of an S3 Bucket for Terraform**. 

## Preliminary work: 

Follow the [Preliminary Work Instructions to prepare Terraform on an AWS Sandbox](preliminary.md) before anything else.

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

### Backend Configuration
Notes: 
* Terraform State will be saved in S3
* Terraform commands will be **run from within an EC2 Instance**. <br> 
The EC2 Instance **must have an IAM Role** attached that allows it to do what's needed (you can always check [Preliminary work](#preliminary-work)).<br>
This is why the `backend.tf` file **does not contain any AWS Keys**.



## Terraform Apply
When running `terraform apply`, you need to pass the following variables: 
* `toto_env` - can be only 'dev' or 'prod'

You can pass vars like this: 
```
terraform apply -var="toto_env=prod"
```