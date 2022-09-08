## POC INSTANCE PDMZ

# defining tls key
resource "tls_private_key" "pdmz" {
  algorithm = "RSA"
  rsa_bits  = 4096
  provider  = tls.key
}

# defining keypair
resource "aws_key_pair" "ec2-key" {
  key_name   = "${var.application_id}-${lower(terraform.workspace)}-ec2-key"
  public_key = tls_private_key.pdmz.public_key_openssh
}

# recovering pem file
resource "local_file" "pem" {
  content  = tls_private_key.pdmz.private_key_pem
  filename = "./pem/${aws_key_pair.ec2-key.key_name}.pem"
  provider = local.pem
}

module "rendr002-pdmz-server01" {
  source    = "./modules/ec2/"
  vpc_id    = data.aws_vpc.pdm.id
  subnet_id = [data.aws_subnet.online-1a.id]

  ec2_instance_name = "${var.application_id}LTOM"
  ec2_sg_name       = "rendr002"
  instance_type     = lookup(var.instance_type, terraform.workspace)
  ami               = lookup(var.ami_id, terraform.workspace)
  key_name          = aws_key_pair.ec2-key.key_name

  # defining instance volumes
  ec2_ebs_volume = [
     {
       device_name = "/dev/xvdb"
       type = "gp2"
       size = lookup(var.ec2_ebs_size_xvdb, terraform.workspace)
     },
     {
       device_name = "/dev/xvdc"
       type = "gp2"
       size = lookup(var.ec2_ebs_size_xvdc, terraform.workspace)
     } 
   ]

  # defining instance tags
  tags = merge(
    local.commons,
    local.backup
  )
}

resource "aws_security_group_rule" "inbound-rules-https" {
  type                      = "ingress"
  to_port                   = 443
  from_port                 = 443
  cidr_blocks               = ["10.0.0.0/8"]
  protocol                  = "tcp"
  security_group_id         = module.rendr002-pdmz-server01.security_group
  description               = "HTTPS Ingress"
}

### Second ENI attached to primary EC2 Instance
resource "aws_network_interface" "eni02" {
  subnet_id           = data.aws_subnet.management-1a.id
  security_groups     = [module.rendr002-pdmz-server01.security_group]
  attachment {
    instance          = module.rendr002-pdmz-server01.instance_id[0]
    device_index      = 1
  }
  tags = {"Name" = "${var.application_id}LTOM-eth2"}
}

