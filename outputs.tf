output "endpoint_arn" {
  description = "The ARN of the Client VPN endpoint"
  value       = aws_ec2_client_vpn_endpoint.client_vpn.arn
}

output "endpoint_dns_name" {
  description = "The DNS name to be used by clients when establishing their VPN session"
  value       = aws_ec2_client_vpn_endpoint.client_vpn.dns_name
}

output "endpoint_id" {
  description = "The ID of the Client VPN endpoint"
  value       = aws_ec2_client_vpn_endpoint.client_vpn.id
}

output "network_association_id" {
  description = "The unique ID of the target network association"
  value       = aws_ec2_client_vpn_network_association.client_vpn.id
}

output "network_association_association_vpc_id" {
  description = "The ID of the VPC in which the target subnet is located"
  value       = aws_ec2_client_vpn_network_association.client_vpn.vpc_id
}

output "aws_route53_record_name" {
  description = "The name of the record"
  value       = aws_route53_record.client_vpn[0].name
}

output "aws_route53_record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = aws_route53_record.client_vpn[0].fqdn
}