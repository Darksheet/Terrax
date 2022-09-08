# defining instance
resource "aws_instance" "ec2" {
  count                   = length(var.subnet_id)
  ami                     = var.ami != null ? var.ami : data.aws_ami.amazon-linux-2.image_id
  instance_type           = var.instance_type
  iam_instance_profile    = aws_iam_instance_profile.ec2-profile.id
  key_name                = var.key_name != null ? var.key_name : aws_key_pair.ec2-key.0.key_name
  user_data               = var.user_data
  placement_group         = var.placement_group
  private_ip              = var.private_ip
  subnet_id               = var.subnet_id[count.index]
  vpc_security_group_ids  = [aws_security_group.ec2-sg.id]
  disable_api_termination = terraform.workspace != "pro" ? "false" : "true"
  source_dest_check       = var.source_dest_check

  # defining root volume
  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      volume_size = root_block_device.value.volume_size
      volume_type = root_block_device.value.volume_type
      iops        = lookup(root_block_device.value, "iops", null)
      throughput  = lookup(root_block_device.value, "throughput", null)
      encrypted   = true
    }
  }

  # defining ephemeral volumes
  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      virtual_name = ephemeral_block_device.value.virtual_name
    }
  }

  # defining tags
  volume_tags = merge(tomap({Name = format("%s%s%s", upper(var.ec2_instance_name), length(var.subnet_id) >= 100 ? "" : length(var.subnet_id) >= 10 ? "0" : "00" , count.index +1)}), {for a, b in var.tags : a => b if ! contains(var.ec2_excluded_tag, a)})
  tags        = merge(tomap({Name = format("%s%s%s",upper(var.ec2_instance_name), length(var.subnet_id) >= 100 ? "" : length(var.subnet_id) >= 10 ? "0" : "00" , count.index +1)}), var.tags)

  # defining lifecycle
  lifecycle {
    ignore_changes = [ami, ebs_optimized]
  }

  
}

# defining volume
resource "aws_ebs_volume" "ec2-volume" {
  count             = length(local.ec2-ebs)
  availability_zone = element(split(",", element(local.ec2-ebs, count.index)), 0)
  type              = element(split(",", element(local.ec2-ebs, count.index)), 1)
  size              = element(split(",", element(local.ec2-ebs, count.index)), 2)
  iops              = element(split(",", element(local.ec2-ebs, count.index)), 3) != "n/a" ? element(split(",", element(local.ec2-ebs, count.index)), 3) : null
  throughput        = element(split(",", element(local.ec2-ebs, count.index)), 4) != "n/a" ? element(split(",", element(local.ec2-ebs, count.index)), 4) : null
  encrypted         = true
  tags              = {for a, b in var.tags : a => b if ! contains(var.ec2_excluded_tag, a)}

  
}

# attaching volume
resource "aws_volume_attachment" "ec2-volume-att" {
  count       = length(local.ec2-ebs)
  volume_id   = element(aws_ebs_volume.ec2-volume.*.id, count.index)
  instance_id = element(split(",", element(local.ec2-ebs, count.index)), 5)
  device_name = element(split(",", element(local.ec2-ebs, count.index)), 6)

  
}
