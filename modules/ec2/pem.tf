# defining tls key
resource "tls_private_key" "key" {
  count     = var.key_name != null ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096


}

# defining keypair
resource "aws_key_pair" "ec2-key" {
  count      = var.key_name != null ? 0 : 1
  key_name   = var.key_name != null ? var.key_name : "${var.ec2_instance_name}-ec2-key"
  public_key = tls_private_key.key.0.public_key_openssh

  # defining tags
  tags = {for a, b in var.tags : a => b if ! contains(var.ec2_excluded_tag, a)}

}
