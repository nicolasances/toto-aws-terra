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
* `certificate_arn`: The ARN of the Certificate that should be used for all HTTPS communications. 
* `gcp_service_account_key`: This variable must contain the content of the GCP Service Account JSON Key file that will (can) be used by AWS-deployed microservices to access GCP resources (e.g. GCS). 

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

### 3. How to get a Certificate? 
If you have a Domain in Route 53, you can attach a certificate to that domain. 

For that, you can use Certificate Manager > Request Certificate. <br>
Once a certificate has been requested, you can go in the "Certificate Details" page and "Create records in Route 53" so that the DNS records to validate the certificate will be created. <br>

#### Common error on TLS: Hostname/IP does not match certificate’s altnames
The first time I requested the Certificate in *Certificate Manager*, in the field *Fully qualified domain name* I only registered the base domain (e.g. *to7o.com*). <br>
The problem is that then, when using Postman to call the API hosted on `https://api.dev.toto.aws.to7o.com/` I got the error `SSL error: Hostname/IP does not match certificate’s altnames`. <br>

After searching a bit, I found that this was due to the fact that the Certificate had to perfectly match the **full hostname** to the Certificate's *altnames* (the *fully qualified domain names* inserted in the certificate request).

> After requesting a certificate with `api.dev.toto.aws.to7o.com` as one of the fully qualified domain names, everything worked fine. <br>

*Note: Using wildcards (*.to7o.com) is NOT possible*.

### What IAM roles are needed by Toto Terraform?
* `AmazonEC2ContainerRegistryFullAccess` to allow Terraform to create and manage an ECR private repo
* `AmazonECS_FullAccess` to allow Terraform to manage ECS resources
* `AmazonRoute53FullAccess` to allow Terraform to manage Route53 
* `AmazonS3FullAccess` to allow Terraform to manage S3 buckets
* `AmazonVPCFullAccess` to give Terraform the right to create and manage VPCs
* `AWSCertificateManagerFullAccess` to allow Terraform to provision certificates 
* `ElasticLoadBalancingFullAccess` to allow Terraform to manage Load Balancers
* `IAMFullAccess` to allow Terraform to create IAM Roles, Users, Groups, etc..
* `SecretsManagerReadWrite` to write Secrets to AWS Secrets Manager