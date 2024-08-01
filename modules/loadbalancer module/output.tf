output "elb_dns_name" {
  value       = aws_elb.demo[0].dns_name
}

