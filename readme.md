# AWS Networking Demo

> Terraform version 0.12.25

## Introduction

Todo

---

## Installation

Todo

---

## Configuration

Todo

---

## Created Resources

Required:
- Region: Singapore
- 1 VPC with DNS & hostname support
- 3 Public subnet in all AZ
- 3 Private subnet in all AZ
- 1 Application Load Balancer that spread in 3 public subnet
- 1 Bastion instance that receive traffic from VPN
- Required output is available in SSM

Test:
- [ ] Instance in Public subnet is accessible by SSH from bastion
- [ ] Instance in Private subner is accessible via bastion

Optional:
- 1 Static S3 website hosting
- 1 Cloudfront distribution
    - Forward all request match /custom-pattern/* to the ALB
    - Default behavior to forward all request to Static S3 website hosting

---

## Tests
```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

instance_private_ip = 10.0.30.32
instance_public_dns = ec2-54-255-153-186.ap-southeast-1.compute.amazonaws.com
```

```
# ~/.ssh/config
# Public subnet
Host ec2-54-169-230-144.ap-southeast-1.compute.amazonaws.com
    User ubuntu
    IdentityFile ~/.ssh/training_fajri.pem
# This covers all hosts within my 10.0.0.0/16 private network
Host 10.0.*
    User ubuntu
    IdentityFile ~/.ssh/training_fajri.pem
    ProxyCommand ssh ubuntu@ec2-54-169-230-144.ap-southeast-1.compute.amazonaws.com -W %h:%p
```
---

## FAQ

---

## Conclusion