# outputs
output "instance_id" {
  value = aws_instance.ec2.*.id
}
output "private_ip" {
  value = aws_instance.ec2.*.private_ip
}
output "iam_role" {
  value = aws_iam_role.ec2-role.name
}
output "iam_instance_profile" {
  value = aws_iam_instance_profile.ec2-profile.id
}
output "security_group" {
  value = aws_security_group.ec2-sg.id
}
output "ec2_private_key" {
  value = var.key_name != null ? "IMPORTED" : tls_private_key.key.0.private_key_pem
}
output "primary_network_interface_id" {
  value = aws_instance.ec2.*.primary_network_interface_id
}


# defining output block
output "output_block" {
  value = <<EOF
# EC2
%{for a in aws_instance.ec2.*.id ~}
|-> + instance ${a} (${lookup(local.ec2-az, a)})
${index(aws_instance.ec2.*.id, a) != length(aws_instance.ec2.*.id)-1 ? "|    |->" : "    |->"} ip             = ${lookup(local.ec2-ip, a)}
${index(aws_instance.ec2.*.id, a) != length(aws_instance.ec2.*.id)-1 ? "|    |->" : "    |->"} instance type  = ${lookup(local.ec2-instance, a)}
${index(aws_instance.ec2.*.id, a) != length(aws_instance.ec2.*.id)-1 ? "|    |->" : "    |->"} security group = ${aws_security_group.ec2-sg.id}
${index(aws_instance.ec2.*.id, a) != length(aws_instance.ec2.*.id)-1 ? "|    |->" : "    |->"} profile        = ${lookup(local.ec2-profile, a)}
${index(aws_instance.ec2.*.id, a) != length(aws_instance.ec2.*.id)-1 ? "|    |->" : "    |->"} root volume    = ${lookup(local.ec2-root, a)}
${index(aws_instance.ec2.*.id, a) != length(aws_instance.ec2.*.id)-1 ? "|    |->" : "    |->"} arn            = ${lookup(local.ec2-arn, a)}
${index(aws_instance.ec2.*.id, a) != length(aws_instance.ec2.*.id)-1 ? "|\n" : "" }%{endfor ~}
EOF
}