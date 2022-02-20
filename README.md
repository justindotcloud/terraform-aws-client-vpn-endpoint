# Terraform AWS Client VPN Endpoint module

Terraform module which creates a Client VPN Endpoint on AWS. This module can be used to quickly create a VPN connection to new and existing VPC's without the use of a VPN instance.

By using self-signed certificates in AWS Systems Manager Parameter Store and a custom subdomain, you can easily create and destroy Client VPN endpoints while reusing the same `*.ovpn` configuration. This way you can create a Client VPN Endpoint only when needed and reduce [costs](https://aws.amazon.com/vpn/pricing/). 

## Terraform versions

Tested with Terraform v1.1.6.

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
module "clientvpn" {
  source = "git::https://github.com/justindotcloud/aws-client-vpn-endpoint.git"

  subnet_id = SUBNET_ID
}
```

You can also add your own subdomain which you can use in the `*.ovpn` configuration file later on. This way you can reuse the same `*.ovpn` configuration when you recreate an AWS Client VPN endpoint. 

```hcl
module "clientvpn" {
  source = "git::https://github.com/justindotcloud/aws-client-vpn-endpoint.git"

  subnet_id = SUBNET_ID
  zone_id   = ZONE_ID
  dns_name  = vpn.example.com
}
```

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| endpoint_description | Description for the VPN endpoint | string | `"terraform-client-vpn-endpoint"` | No |
| client_cidr_block | Client CIDR used for the VPN endpoint | string | `"10.0.0.0/16"` | No |
| transport_protocol | Transport protocol used for the VPN endpoint | string | `"tcp"` | No |
| dns_servers | DNS servers used for the VPN endpoint | list | `["8.8.8.8", "8.8.4.4"]` | No |
| subnet_id | Subnet ID used for the VPN endpoint | string | n/a| Yes |
| client_vpn_ingress_cidr_block | Client ingress CIDR used for the VPN endpoint | string | `"0.0.0.0/0"` | No |
| client_vpn_route_internet_cidr_block | Route table CIDR used for the VPN endpoint | string | `"0.0.0.0/0"` | No |
| zone_id | ID of the DNS zone used for the VPN endpoint | string | `""` | No |
| dns_name | Name of the custom DNS record used for the VPN endpoint | string | `""` | No |
| ssm_server_crt | Parameter store location for server.crt for the VPN endpoint | string | `"/clientvpn/certificates/server.crt"` | No |
| ssm_server_key | Parameter store location for server.key for the VPN endpoint | string | `"/clientvpn/certificates/server.key"` | No |
| ssm_client_crt | Parameter store location for client.crt for the VPN endpoint | string | `"/clientvpn/certificates/client.crt"` | No |
| ssm_client_key | Parameter store location for client.key for the VPN endpoint | string | `"/clientvpn/certificates/client.key"` | No |
| ssm_ca_crt | Parameter store location for ca.crt for the VPN endpoint | string | `"/clientvpn/certificates/ca.crt"`| No |
| tags | Tags for all resources used for the VPN endpoint | map | `{}` | No |

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

## Authors

Module managed by [Justin Janson](https://github.com/justindotcloud)