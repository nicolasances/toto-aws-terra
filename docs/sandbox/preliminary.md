# Preparing Terraform on an AWS Sandbox

This guide goes through the configuration of Terraform on an AWS Sandbox (aka restricted environment where you don't have all the permissions - e.g. creation of an IAM User, ...).

The folder `scripts` in the root of this project contains a `dev.sh` and a `prod.sh`. <br>
These scripts basically **setup the TF_VAR environment variables** that are needed by Terraform. 

You will see the following variables that are important to check: 
* `TF_VAR_aws_region` - make sure it's the **right region**.
* `TF_VAR_code_connection_arn` - you need to [Create a Code Connection](#create-a-code-connection). Once that is done, fill this var with the ARN of the Code Connection.
* `TF_VAR_code_connection_hash` - once you have a Code Connection, this is just the last part of the code connection ARN. <br>
For example, if your Code Connection ARN is `arn:aws:codeconnections:eu-north-1:787222310702:connection/37cdb817-9ca7-40ad-a811-301226c66e09`, then this variable should be filled with the last part: `37cdb817-9ca7-40ad-a811-301226c66e09`
* `TF_VAR_alb_certificate_arn` - this is the ARN of the Certificate to be used for the HTTPS listener in your ALB. You need to follow the chapter [Domain, Certificate & Load Balancer](#domain-certificate--load-balancer) here below. 

## Create a Bucket for tfsate
S3 → Create bucket for tfstate (**enable versioning**, **enable server-side encryption**).

## Domain, Certificate & Load Balancer
**VERY IMPORTANT**. 

You might have noticed that among the TF Variables, there's one called `TF_VAR_alb_certificate_arn`. <br>
You need a Certificate **BEFORE** running `terraform apply`. 

So the correct steps are: 
1. Buy a Domain 
2. Go on *Certificate Manager > Request certificate*. 
3. *Request a public certificate*
4. Give the FQDN: e.g. `api.toto.prod.your-domain`. <br>
Leave the rest as is (DNS validation, Disable export, etc..). 
5. Now the request has been fired and is in "Pending Validation". <br>
It does not matter: **NOW YOU HAVE THE ARN YOU NEED FOR TERRAFORM**. <br>
Copy that ARN and used it in the `<env>.sh` script under `/scripts`.
6. You can click on "Create DNS Records". That will register the certificate by creating DNS Records in your Hosted Zone (the domain you bought at step 1).<br>
Soon the certificate will be with *Status* "Issued". 

## Create a Code Connection
**IMPORTANT NOTE**: you onle need **ONE Code Connection** that will cover both environments. 

You need to create a code connection that will allow the CI/CD Pipeline (AWS CodePipeline) to connect to Github and monitor your code for automated deployment, as well as pull the code.

To do that [follow the Create Code Connection guide on my aws-notes repo](https://github.com/nicolasances/aws-notes/blob/main/docs/ecs/toto-ecs-cicd.md#code-connection).

## Setting up a VM for Terraform
We will use a VM with SSH access to allow an administrator to run its Terraform commands.

### Create a Role for the VM 
The VM will need a IAM Role that gives it the right permissions to run Terraform and manage the infrastructure. 

* Open the AWS Console → IAM → Roles → Create role.
* Select AWS service → EC2 as the trusted entity → Next.
* Attach managed policy `AmazonSSMManagedInstanceCore` (required for Session Manager).
* Attach managed policy `AdministratorAccess`


Example of the configuration: 
![Role creation for EC2 Role](./img/ec2-role-terra.png)

### Launch the EC2 Instance
Launch with: 
* AMI: choose Amazon Linux 2023 or Amazon Linux 2
* Instance type `t3-small`
* Attach a VPC and a subnet that has internet access
* Make sure it has a **public IP** 
* Enable access through SSH

After creation: 
* Make sure you add the IAM Role you configured before. 

SSH into the VM and run the following: 
```
sudo su

yum update -y 

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
unzip -q /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install --update || sudo /tmp/aws/install

# Install Terraform
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo || true
yum -y install terraform || true

# Enable SSM agent
systemctl enable amazon-ssm-agent || true
systemctl start amazon-ssm-agent  || true

# Create a terraform workspace directory
mkdir -p /home/ec2-user/terraform
chown -R ec2-user:ec2-user /home/ec2-user/terraform

# Install Git
dnf install -y git

```

After that, you should be able to verify installation: 
```
# confirm identity (shows the IAM role credentials in use)
aws sts get-caller-identity

# check terraform & aws
terraform -version
aws --version
git --version

# quick directory
ls -la /home/ec2-user/terraform
```

