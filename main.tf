resource "aws_ec2_client_vpn_endpoint" "client_vpn" {
  description            = var.endpoint_description
  server_certificate_arn = aws_acm_certificate.server.arn
  client_cidr_block      = var.client_cidr_block
  transport_protocol     = var.transport_protocol
  dns_servers            = var.dns_servers

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.client.arn
  }

  connection_log_options {
    enabled = false
  }

  tags = var.tags
}

resource "aws_ec2_client_vpn_network_association" "client_vpn" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn.id
  subnet_id              = var.subnet_id
}

resource "aws_ec2_client_vpn_authorization_rule" "client_vpn" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn.id
  target_network_cidr    = var.client_vpn_ingress_cidr_block
  authorize_all_groups   = true

  timeouts {
    create = "15m"
  }
}

resource "aws_ec2_client_vpn_route" "client_vpn" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn.id
  destination_cidr_block = var.client_vpn_route_internet_cidr_block
  target_vpc_subnet_id   = var.subnet_id

  timeouts {
    create = "15m"
  }
}