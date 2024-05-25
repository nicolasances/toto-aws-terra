# AWS Terraform modules for Toto
This repo contains all the Terraform modules to control the AWS infrastructure and deployments of Toto.

## Configuring Terraform Authentication to AWS
To allow Terraform to perform operations on AWS, you need to create a IAM User on AWS, assign the right permissions and create a key to be used in the Terraform AWS Provider configuration. 

### 1. Create a User and User Group on AWS IAM
Create a new User and a User Group for the Terraform User. <br>
In the User Group, I specified the following Policies: 
* `AmazonVPCFullAccess` to give Terraform the right to create and manage VPCs

Once the User is created, you need to **create Security Credentials** to give to Terraform AWS Provider.<br>
On the User > Security Credentials, create a new **Access Key**.

On [Terraform Cloud](https://app.terraform.io), in my project, I created the following Terraform Variables: 
* `aws_access_key` with the Access Key
* `aws_secret_access_key` with the Secret Access Key

Sources: 
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration