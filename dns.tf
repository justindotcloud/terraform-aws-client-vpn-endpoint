resource "aws_route53_record" "client_vpn" {
  count = var.zone_id != "" && var.dns_name != "" ? 1 : 0

  zone_id = var.zone_id 
  name    = format("%s.%s","*",var.dns_name)
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_ec2_client_vpn_endpoint.client_vpn.dns_name}"]
}
