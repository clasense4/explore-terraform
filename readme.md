# AWS Terraform

## Introduction

This project goal is to create several resources using terraform.  
The list of resources is listed below.  
This project is using terraform version `0.12.25`.  

---

## Installation

```
git clone git@github.com:clasense4/terraform-demo.git
cd terraform-demo
./install.sh
```

---

## Configuration

All configuration is available on `vars/*.tfvars`.  
Change the value of `vpn_cidr_block` at `vars/network.tfvars` with your VPN IP adress.  
Also possible to use the current internet public ip, but be careful.  
> curl ifconfig.co

Anything else can leave by default.  

---

## Deploy

```
export AWS_PROFILE=fajri
export AWS_DEFAULT_REGION="ap-southeast-1"

> available mode: apply & destroy.

./terraform.sh apply network prod && ./terraform.sh apply application prod && ./terraform.sh apply test default
```
---

## Resources

- 1 VPC with DNS & hostname support
- 3 Public subnet in all AZ
- 3 Private subnet in all AZ
- 1 Application Load Balancer that spread in 3 public subnet
- 1 Static S3 website hosting
- 1 Cloudfront distribution
    - Forward all request match /istox-testing/* to the ALB
    - Default behavior to forward all request to Static S3 website hosting
- Some output is available on SSM
---

## Tests

### 1. SSH to instance in private subnet

After executing `./terraform.sh apply test default` there is an output like below :

```
Outputs:

instance_private_ip = 10.0.31.229
instance_public1_dns = ec2-54-255-166-119.ap-southeast-1.compute.amazonaws.com
instance_public2_dns = ec2-18-138-239-66.ap-southeast-1.compute.amazonaws.com
```

Choose 1 instance public dns, and add this block below to your `~/.ssh/config` file :


```
# Public subnet
Host ec2-54-255-166-119.ap-southeast-1.compute.amazonaws.com
    User ubuntu
    IdentityFile ~/.ssh/training_fajri.pem
# This covers all hosts within my 10.0.0.0/16 private network
Host 10.0.*
    User ubuntu
    IdentityFile ~/.ssh/training_fajri.pem
    ProxyCommand ssh ubuntu@ec2-54-255-166-119.ap-southeast-1.compute.amazonaws.com -W %h:%p
```

After the setup complete, now we can SSH directly to the private instance.

```
ssh -i "training_fajri.pem" ubuntu@10.0.31.229
```

We can't do anything to the instance right now, since there is no internet access in the private subnet.

---

### 2. Accessing ELB and cloudfront distribution

Retrieve all available value from ssm with this command.

```
# ALB DNS
aws ssm get-parameter --name /istox/alb/dns | jq -r '.Parameter.Value'
# Example, refresh several times to see load balancing in action
istox-aws-alb-1503816018.ap-southeast-1.elb.amazonaws.com

# S3 website endpoint
aws ssm get-parameter --name /istox/s3/website_endpoint | jq -r '.Parameter.Value'
# Example
frontend.serverless.my.id.s3-website-ap-southeast-1.amazonaws.com

# Cloudfront dns
aws ssm get-parameter --name /istox/cloudfront/domain | jq -r '.Parameter.Value'
# Example
d1fjc6y2yegq2z.cloudfront.net
d1fjc6y2yegq2z.cloudfront.net/istox-testing/1
d1fjc6y2yegq2z.cloudfront.net/istox-testing/2
d1fjc6y2yegq2z.cloudfront.net/istox-testing/3
```

> Open with google chrome incognito or firefox private browsing to make sure there is no local cache
---

## Destroy
```
./terraform.sh destroy test default && ./terraform.sh destroy application prod && ./terraform.sh destroy network prod
```
---

## Improvement

1. Add Bastion host with a static IP address
2. Add RDS with read replica in another AZ to test the connection is fine
3. Add NAT gateway to enable internet access on private subnet
4. Add `env` variable, so we can have multiple version in 1 account, useful for dev and staging
    > istox-dev-1, istox-staging-2
5. Workspace is used, but without `env` var support means nothing
6. Can have multiple stage of `/vars/` for example `/vars/prod/*.tfvars` and combine it with workspace
