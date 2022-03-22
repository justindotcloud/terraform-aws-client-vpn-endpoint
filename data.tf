data "aws_region" "current" {}

data "aws_ssm_parameter" "server_crt" {
  name = var.ssm_server_crt
}

data "aws_ssm_parameter" "server_key" {
  name            = var.ssm_server_key
  with_decryption = true
}

data "aws_ssm_parameter" "client_crt" {
  name = var.ssm_client_crt
}

data "aws_ssm_parameter" "client_key" {
  name            = var.ssm_client_key
  with_decryption = true
}

data "aws_ssm_parameter" "ca_crt" {
  name = var.ssm_ca_crt
}