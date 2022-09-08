# defining locals
locals {
  ec2-az = { 
    for a in aws_instance.ec2 : a.id => a.availability_zone
  }
  ec2-ip = { 
    for a in aws_instance.ec2 : a.id => a.private_ip
  }
  ec2-instance = { 
    for a in aws_instance.ec2 : a.id => a.instance_type
  }
  ec2-profile = { 
    for a in aws_instance.ec2 : a.id => a.iam_instance_profile
  }
  ec2-root = {
    for a in aws_instance.ec2 : a.id => a.root_block_device.0.volume_id
  }
  ec2-ebs = flatten([ 
    for a in aws_instance.ec2 : [
      for b in var.ec2_ebs_volume : format("%s,%s,%s,%s,%s,%s,%s",a.availability_zone,b.type,b.size,lookup(b, "iops", "n/a"),lookup(b, "throughput", "n/a"),a.id,b.device_name)
    ]
  ])
  ec2-arn = { 
    for a in aws_instance.ec2 : a.id => a.arn
  }
}