# defining instace role
resource "aws_iam_role" "ec2-role" {
  name = lower(var.ec2_instance_name)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

# defining tags
tags = {for a, b in var.tags : a => b if ! contains(var.ec2_excluded_tag, a)}



}

# required for system manager
resource "aws_iam_role_policy_attachment" "ec2-role-policy" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

  
}

# defining any other policy
resource "aws_iam_role_policy_attachment" "ec2-role-policy-customs" {
  count      = length(var.ec2_instance_policies)
  policy_arn = var.ec2_instance_policies[count.index]
  role       = aws_iam_role.ec2-role.id

  
}

# defining instance profile
resource "aws_iam_instance_profile" "ec2-profile" {
  name = lower(var.ec2_instance_name)
  role = aws_iam_role.ec2-role.name

  
}

resource "aws_iam_role_policy" "ec2-policy-ssm-agent" {
  name   = "${lower(var.ec2_instance_name)}-ssm-agent"
  role   = aws_iam_role.ec2-role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": [
         "arn:aws:s3:::aws-windows-downloads-eu-west-1/*",
         "arn:aws:s3:::amazon-ssm-eu-west-1/*",
         "arn:aws:s3:::amazon-ssm-packages-eu-west-1/*",
         "arn:aws:s3:::eu-west-1-birdwatcher-prod/*",
         "arn:aws:s3:::aws-ssm-document-attachments-eu-west-1/*",
         "arn:aws:s3:::patch-baseline-snapshot-eu-west-1/*",
         "arn:aws:s3:::aws-ssm-eu-west-1/*",
         "arn:aws:s3:::aws-patchmanager-macos-eu-west-1/*"
      ]
    }
]
}
POLICY

  
}
