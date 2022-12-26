variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "k8s_cluster_version" {
  description = "The Kubernetes cluster version to use"
  type        = string
  default     = "1.22"
}

variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  # description = "Name of the project deployment."
  type = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "DEMO"
    "Stage"       = "POC"
    "Environment" = "Development"
    "Owner"       = "Chandan Ghosh"
    "Terraform"   = true
  }
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::<accound_id>:role/<role_name>" # Update account_id and role_name of the current logged in web console user.
      username = "Chandan.Ghosh"                              # IAM User name
      groups   = ["system:masters"]                           # Default group of aws_auth configmap to access k8s resources from web console
    },

  ]
}

########################
## K8S APP
########################

variable "app_namespace" {
  type    = string
  default = "app"
}

variable "app_docreg" {
  type    = string
  default = "app-docreg"
}

variable "app_registry_server" {
  type    = string
  default = "appregistry.azurecr.io"
}

variable "app_registry_username" {
  type    = string
  default = "appregistry"
}

variable "app_registry_password" {
  type    = string
  default = "apppassword"
}
