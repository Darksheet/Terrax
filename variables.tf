# defining environment variables
variable "region" {
  default = "eu-west-1"
}

variable "project" {
  default = "Appliance"
}

variable "application_id" {
  default = "RENDR002"
}

variable "domain_account" {
  default = "PDM"
}

variable "instance_type" {
  type = map(any)
  default = {
    "dev" = ""
    "pre" = ""
    "pro" = "m6a.xlarge"
  }
}

variable "ami_id" {
  type = map(any)
  default = {
    "dev" = ""
    "pre" = ""
    "pro" = "ami-09e2d756e7d78558d" ### Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  }
}

variable "ec2_key_pair_name" {
  type = map(any)
  default = {
    "dev" = ""
    "pre" = ""
    "pro" = "rendr002pem"
  }
}

variable "backup_plan" {
  type = map
  default = {
    "dev"  = ""
    "pre"  = ""
    "pro"  = "gold"
  }
}


variable "ec2_ebs_size_xvdb" {
  type = map
  default = {
    "dev"  = ""
    "pre"  = ""
    "pro"  = "20"
  }
}
variable "ec2_ebs_size_xvdc" {
  type = map
  default = {
    "dev"  = ""
    "pre"  = ""
    "pro"  = "20"
  }
}
