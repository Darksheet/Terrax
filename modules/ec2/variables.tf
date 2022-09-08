# common inputs
variable "key_name" {
  default = null
}
variable "private_ip" {
  default = null
}
variable "placement_group" {
  default = null
}
variable "vpc_id" {}
variable "subnet_id" {
  type    = list
  default = []
}
variable "instance_type" {}
variable "ami" {
  default = null
}
variable "root_block_device" {
  type    = list
  default = []
}
variable "ephemeral_block_device" {
  type    = list
  default = []
}
variable "user_data" {
  default = null
}
variable "tags" {
  type = map
  default = {}
}
variable "region" {
  default = null
}

# custom module inputs
variable "ec2_instance_name" {}

variable "ec2_sg_name" {}

variable "ec2_instance_port" {
  default = "22" # just in case u dont prefer linux ;)
}
variable "ec2_ebs_volume" {
  type    = list
  default = []
}
variable "ec2_instance_policies" {
  type    = list
  default = []
}
variable "ec2_excluded_tag" {
  type    = list
  default = [
    "Schedule",
    "InstanceControl",
    "Backup",
    "Patch Group"
  ]
}

variable "source_dest_check" {
  default = true
}
