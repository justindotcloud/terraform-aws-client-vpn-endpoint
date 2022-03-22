variable "endpoint_description" {
  description = "Description for the VPN endpoint"
  type        = string
  default     = "terraform-client-vpn-endpoint"
}

variable "client_cidr_block" {
  description = "Client CIDR used for the VPN endpoint"
  type        = string
  default     = "10.0.0.0/16"
}

variable "transport_protocol" {
  description = "Transport protocol used for the VPN endpoint"
  type        = string
  default     = "tcp"
}

variable "dns_servers" {
  description = "DNS servers used for the VPN endpoint"
  type        = list(any)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "subnet_id" {
  description = "Subnet ID used for the VPN endpoint"
  type        = string
}

variable "client_vpn_ingress_cidr_block" {
  description = "Client ingress CIDR used for the VPN endpoint"
  type        = string
  default     = "0.0.0.0/0"
}

variable "client_vpn_route_internet_cidr_block" {
  description = "Route table CIDR used for the VPN endpoint"
  type        = string
  default     = "0.0.0.0/0"
}

variable "zone_id" {
  description = "ID of the DNS zone used for the VPN endpoint"
  type        = string
  default     = ""
}

variable "dns_name" {
  description = "Name of the custom DNS record used for the VPN endpoint"
  type        = string
  default     = ""
}

variable "ssm_server_crt" {
  description = "Parameter store location for server.crt for the VPN endpoint"
  type        = string
  default     = "/clientvpn/certificates/server.crt"
}

variable "ssm_server_key" {
  description = "Parameter store location for server.key for the VPN endpoint"
  type        = string
  default     = "/clientvpn/certificates/server.key"
}

variable "ssm_client_crt" {
  description = "Parameter store location for client.crt for the VPN endpoint"
  type        = string
  default     = "/clientvpn/certificates/client.crt"
}

variable "ssm_client_key" {
  description = "Parameter store location for client.key for the VPN endpoint"
  type        = string
  default     = "/clientvpn/certificates/client.key"
}

variable "ssm_ca_crt" {
  description = "Parameter store location for ca.crt for the VPN endpoint"
  type        = string
  default     = "/clientvpn/certificates/ca.crt"
}

variable "tags" {
  description = "Tags for all resources used for the VPN endpoint"
  type        = map(any)
  default     = {}
}