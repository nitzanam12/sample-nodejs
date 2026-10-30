variable "admin_cidr" {
  description = "Allowed CIDR for public EKS API access"
  type        = string
}
# export TF_VAR_admin_cidr="$(curl -4fsS https://checkip.amazonaws.com | tr -d '\n')/32"