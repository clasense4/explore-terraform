# AWS Networking Demo

## Resources

Required:
- Region: Singapore
- 1 VPC with DNS & hostname support
- 3 Public subnet in all AZ
- 3 Private subnet in all AZ
- 1 Application Load Balancer that spread in 3 public subnet
- 1 Bastion instance that receive traffic from VPN

Test:
- [ ] Instance in Public subnet is accessible by SSH from bastion
- [ ] Instance in Private subner is accessible via bastion

Optional:
- 1 Static S3 website hosting
- 1 Cloudfront distribution
    - Forward all request match /custom-pattern/* to the ALB
    - Default behavior to forward all request to Static S3 website hosting

