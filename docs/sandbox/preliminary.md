# Preparing Terraform on an AWS Sandbox

This guide goes through the configuration of Terraform on an AWS Sandbox (aka restricted environment where you don't have all the permissions - e.g. creation of an IAM User, ...).

## Create a Bucket for tfsate
S3 → Create bucket for tfstate (**enable versioning**, **enable server-side encryption**).

## Setting up a VM
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
