output "vpc_id" {
  description = "VPC ID"
  value       = concat(aws_vpc.this.*.id, [""])[0]
}
