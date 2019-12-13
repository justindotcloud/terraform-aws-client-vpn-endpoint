resource "aws_acm_certificate" "server" {
  certificate_body  = data.aws_ssm_parameter.server_crt.value
  private_key       = data.aws_ssm_parameter.server_key.value
  certificate_chain = data.aws_ssm_parameter.ca_crt.value

  tags = var.tags
}

resource "aws_acm_certificate" "client" {
  certificate_body  = data.aws_ssm_parameter.client_crt.value
  private_key       = data.aws_ssm_parameter.client_key.value
  certificate_chain = data.aws_ssm_parameter.ca_crt.value

  tags = var.tags
}
