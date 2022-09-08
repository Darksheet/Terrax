# defining main sg
resource "aws_security_group" "ec2-sg" {
  name        = var.ec2_sg_name
  description = var.ec2_sg_name
  vpc_id      = var.vpc_id

  # defining tags
  tags = merge( {Name = var.ec2_sg_name}, {for a, b in var.tags : a => b if ! contains(var.ec2_excluded_tag, a)})
 
  # defining lifecycle
  lifecycle {
    create_before_destroy = true
  }

}

# defining egress rules
resource "aws_security_group_rule" "ec2-sg-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2-sg.id

}

