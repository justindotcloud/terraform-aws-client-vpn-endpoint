# Terraform AWS Client VPN Endpoint module

Terraform module which creates a Client VPN Endpoint on AWS. This module can be used to quickly create a VPN connection to new and existing VPC's without the use of a VPN instance.

By using self-signed certificates in AWS Systems Manager Parameter Store and a custom subdomain, you can easily create and destroy Client VPN endpoints while reusing the same `*.ovpn` configuration. This way you can create a Client VPN Endpoint only when needed and reduce [costs](https://aws.amazon.com/vpn/pricing/).

## Usage

#### Self-signed certificates

Pre-genereted self-signed certificates are used to be able to reuse the same `*.ovpn` configuration. Get started by generating self-signed server and client certificates using [this guide](https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/authentication-authorization.html) from AWS.

Store the self-signed certificates in AWS Systems Manager Parameter Store when generated.

```
$ aws ssm put-parameter --name /clientvpn/certificates/server.crt --type String --value "$(cat server.crt)"

$ aws ssm put-parameter --name /clientvpn/certificates/server.key --type SecureString --value "$(cat server.key)"

$ aws ssm put-parameter --name /clientvpn/certificates/client.crt --type String --value "$(cat client.crt)"

$ aws ssm put-parameter --name /clientvpn/certificates/client.key --type SecureString --value "$(cat client.key)"

$ aws ssm put-parameter --name /clientvpn/certificates/ca.crt --type String --value "$(cat ca.crt)"

```

#### Examples

This is the minimum configuration needed to create an AWS Client VPN endpoint.

```hcl
module "client-vpn-endpoint" {
  source  = "justindotcloud/client-vpn-endpoint/aws"
  version = "0.1.0"

  subnet_id = SUBNET_ID
}
```

You can also add your own subdomain which you can use in the `*.ovpn` configuration file later on. This way you can reuse the same `*.ovpn` configuration when you recreate an AWS Client VPN endpoint. 

```hcl
module "client-vpn-endpoint" {
  source  = "justindotcloud/client-vpn-endpoint/aws"
  version = "0.1.0"

  subnet_id = SUBNET_ID
  zone_id   = ZONE_ID
  dns_name  = vpn.example.com
}
```

#### VPN configuration file

Download the AWS Client VPN configuration via the AWS Console and add the following two lines of code:

```
cert /PATH/TO/client.crt
key /PATH/TO/client.key
```

Optionally modify the DNS endpoint if you added your own subdomain.


```
remote vpn.example.com 443
```

Add the `*.ovpn` configuration file to your prefered client and connect to VPN.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_ec2_client_vpn_authorization_rule.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |
| [aws_ec2_client_vpn_endpoint.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_endpoint) | resource |
| [aws_ec2_client_vpn_network_association.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_network_association) | resource |
| [aws_ec2_client_vpn_route.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route) | resource |
| [aws_route53_record.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.ca_crt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.client_crt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.client_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.server_crt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.server_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_cidr_block"></a> [client\_cidr\_block](#input\_client\_cidr\_block) | Client CIDR used for the VPN endpoint | `string` | `"10.0.0.0/16"` | no |
| <a name="input_client_vpn_ingress_cidr_block"></a> [client\_vpn\_ingress\_cidr\_block](#input\_client\_vpn\_ingress\_cidr\_block) | Client ingress CIDR used for the VPN endpoint | `string` | `"0.0.0.0/0"` | no |
| <a name="input_client_vpn_route_internet_cidr_block"></a> [client\_vpn\_route\_internet\_cidr\_block](#input\_client\_vpn\_route\_internet\_cidr\_block) | Route table CIDR used for the VPN endpoint | `string` | `"0.0.0.0/0"` | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | Name of the custom DNS record used for the VPN endpoint | `string` | `""` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | DNS servers used for the VPN endpoint | `list(any)` | <pre>[<br>  "8.8.8.8",<br>  "8.8.4.4"<br>]</pre> | no |
| <a name="input_endpoint_description"></a> [endpoint\_description](#input\_endpoint\_description) | Description for the VPN endpoint | `string` | `"terraform-client-vpn-endpoint"` | no |
| <a name="input_ssm_ca_crt"></a> [ssm\_ca\_crt](#input\_ssm\_ca\_crt) | Parameter store location for ca.crt for the VPN endpoint | `string` | `"/clientvpn/certificates/ca.crt"` | no |
| <a name="input_ssm_client_crt"></a> [ssm\_client\_crt](#input\_ssm\_client\_crt) | Parameter store location for client.crt for the VPN endpoint | `string` | `"/clientvpn/certificates/client.crt"` | no |
| <a name="input_ssm_client_key"></a> [ssm\_client\_key](#input\_ssm\_client\_key) | Parameter store location for client.key for the VPN endpoint | `string` | `"/clientvpn/certificates/client.key"` | no |
| <a name="input_ssm_server_crt"></a> [ssm\_server\_crt](#input\_ssm\_server\_crt) | Parameter store location for server.crt for the VPN endpoint | `string` | `"/clientvpn/certificates/server.crt"` | no |
| <a name="input_ssm_server_key"></a> [ssm\_server\_key](#input\_ssm\_server\_key) | Parameter store location for server.key for the VPN endpoint | `string` | `"/clientvpn/certificates/server.key"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID used for the VPN endpoint | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for all resources used for the VPN endpoint | `map(any)` | `{}` | no |
| <a name="input_transport_protocol"></a> [transport\_protocol](#input\_transport\_protocol) | Transport protocol used for the VPN endpoint | `string` | `"tcp"` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | ID of the DNS zone used for the VPN endpoint | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_route53_record_fqdn"></a> [aws\_route53\_record\_fqdn](#output\_aws\_route53\_record\_fqdn) | FQDN built using the zone domain and name |
| <a name="output_aws_route53_record_name"></a> [aws\_route53\_record\_name](#output\_aws\_route53\_record\_name) | The name of the record |
| <a name="output_endpoint_arn"></a> [endpoint\_arn](#output\_endpoint\_arn) | The ARN of the Client VPN endpoint |
| <a name="output_endpoint_dns_name"></a> [endpoint\_dns\_name](#output\_endpoint\_dns\_name) | The DNS name to be used by clients when establishing their VPN session |
| <a name="output_endpoint_id"></a> [endpoint\_id](#output\_endpoint\_id) | The ID of the Client VPN endpoint |
| <a name="output_network_association_association_vpc_id"></a> [network\_association\_association\_vpc\_id](#output\_network\_association\_association\_vpc\_id) | The ID of the VPC in which the target subnet is located |
| <a name="output_network_association_id"></a> [network\_association\_id](#output\_network\_association\_id) | The unique ID of the target network association |
<!-- END_TF_DOCS -->

## Authors

Module managed by [Justin Janson](https://github.com/justindotcloud).