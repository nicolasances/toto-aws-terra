# AWS Terraform modules for Toto
This repo contains all the Terraform modules to control the AWS infrastructure and deployments of Toto.

## Configuring Terraform Authentication to AWS
To allow Terraform to perform operations on AWS, you need to create a IAM User on AWS, assign the right permissions and create a key to be used in the Terraform AWS Provider configuration. 

### 1. Core Variables
Toto Terraform modules need **at least** the following variables: 
* `toto_environment`: The Toto Environment (e.g. `dev`, `prod`, etc..)
* `aws_access_key`: AWS Access Key for the Toto Terraform User
* `aws_secret_access_key`: AWS Secret Access Key for the Toto Terraform User
* `jwt_signing_key`: The key used by Toto to sign JWT Tokens
* `github_token`: The PAT token to be used to manage Github Repos

### 2. Create a User and User Group on AWS IAM
Create a new User and a User Group for the Terraform User. <br>
In the User Group, I specified the following Policies: 
* `AmazonVPCFullAccess` to give Terraform the right to create and manage VPCs

Note: **make sure to add the User to the Group**. Creating a Group contextually with the creation of the User apparently is not enough to be sure that the two are linked!

Once the User is created, you need to **create Security Credentials** to give to Terraform AWS Provider.<br>
On the User > Security Credentials, create a new **Access Key**.

On [Terraform Cloud](https://app.terraform.io), in my project, I created the following Terraform Variables: 
* `aws_access_key` with the Access Key
* `aws_secret_access_key` with the Secret Access Key

Sources: 
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration

### What IAM roles are needed by Toto Terraform?
* `AmazonVPCFullAccess` to give Terraform the right to create and manage VPCs
* `SecretsManagerReadWrite` to write Secrets to AWS Secrets Manager
* `IAMFullAccess` to allow Terraform to create IAM Roles, Users, Groups, etc..
* `AmazonECS_FullAccess` to allow Terraform to manage ECS resources
* `ElasticLoadBalancingFullAccess` to allow Terraform to manage Load Balancers