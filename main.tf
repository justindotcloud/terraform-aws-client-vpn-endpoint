resource "aws_ec2_client_vpn_endpoint" "client_vpn" {
  description            = var.endpoint_description
  server_certificate_arn = aws_acm_certificate.server.arn
  client_cidr_block      = var.client_cidr_block
  transport_protocol	 = var.transport_protocol
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

resource "null_resource" "client_vpn_ingress" {
  provisioner "local-exec" {
    when    = create
    command = "aws ec2 authorize-client-vpn-ingress --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.client_vpn.id} --target-network-cidr ${var.client_vpn_ingress_cidr_block} --authorize-all-groups"
  }
}

resource "null_resource" "client_vpn_route_internet" {
  provisioner "local-exec" {
    when    = create
    command = "aws ec2 create-client-vpn-route --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.client_vpn.id} --destination-cidr-block ${var.client_vpn_route_internet_cidr_block} --target-vpc-subnet-id ${var.subnet_id}"
  }
 
  depends_on = [aws_ec2_client_vpn_network_association.client_vpn]
}
