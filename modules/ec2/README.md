# EC2 module

This particular module generates below resources:

- EC2 instance(s) based on subnet count.
- EBS volumes (***linked to the instance(s)***).
- Security group (***linked to the instance(s)***).
- Entry at RepsolEyG private Route53 zone (***linked to the instance(s)***).

## Integration(s):

| Platform | Module | Enabled | Description |
| ------ | ------ | ------ | ------ |
| Argos | Hades | true | Standar integration at EC2 level. |
| Argos | Hipnos | true | Standar integration + vertical autoscalling allowed. |
| Soteria | Egida | false | EC2 does not require WAF or Shield. |

# HowTo...

## Source:

```
module "ec2-test" {
  source = "git::https://atlas.rg.repsol.com/arquitectura-group/plt003-argos/plt003-argos-horas.git//ec2/?ref=vx.y.z"

```

## Input parameters:

| Input | Type | Required | Description |
| ------ | ------ | ------ | ------ |
| ami | string | no | If not defined will match latest amazon linux 2. |
| key_name | string | no | Just in case you are importing already deployed EC2 instances. |
| user_data | string | no | The user data to provide when launching the instance. |
| instance_type | string | yes | The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance. |
| ephemeral_block_device | listt | no | Instance volumes (ephemeral) devices to attach to the instance. Ephemeral device configurations only apply on resource creation. |
| vpc_id | string | yes | The VPC id. |
| subnet_id | list | yes | Base on the amount of subnets the module generates the same amount of instances. |
| root_block_device | list | no | Root volume definition. |
| ec2_ebs_volume | list | no | Additional EBS block devices to attach to the instance. Block device configurations only apply on resource creation. |
| placement_group | string | no | The placement group to deploy the EC2 instances. |
| ec2_instance_policies | list | no | Define required policies for instance profile. |
| ec2_instance_name | string | yes | Define instance name. |
| ec2_instance_port | number | no | The bastion ip to access via ssh. **Default is 22.** |
| security_groups_extra | list | no | Extra security groups to attach to the EC2 |
| tags | map | yes | Resources tags, keep in mind mandatory ones. |

## Outputs:

| Output | Type | Description |
| ------ | ------ | ------|
| module.ec2-test.instance_id | list | Instances ids. |
| module.ec2-test.security_group | string | Security group id. |
| module.ec2-test.iam_role | string | Instance role name. |
| module.ec2-test.iam_instance_profile | string | Instance profile id. |
| module.ec2-test.private_ip | list | Instances private ips. |
| module.ec2-test.ec2_private_dns | list | RepsolEyG private zone entries. |
| module.ec2-test.ec2_private_key | string | Private key (PEM), **just for not imported EC2 instances**. |

## Usage examples:

### a) Simple module call just one ec2:

```
module "ec2-test" {
  source = "git::https://atlas.rg.repsol.com/arquitectura-group/plt003-argos/plt003-argos-horas.git//ec2/?ref=vx.y.z"

  # commons inputs
  instance_type     = "t3a.medium"
  vpc_id            = module.vpc.vpc_id
  subnet_id         = [module.vpc.subnet_priv_a_id]

  # custom inputs
  ec2_instance_name = "${var.application_id}TEST"

  # defining tags
  tags = merge(
    local.commons,
    local.ec2,
    local.backup,
  )
}

```

### b) Module call ec2 cluster (3AZs) with instance profile and volumes definitios:

```
module "ec2-test" {
  source = "git::https://atlas.rg.repsol.com/arquitectura-group/plt003-argos/plt003-argos-horas.git//ec2/?ref=vx.y.z"

  # commons inputs
  instance_type     = "t3a.medium"
  vpc_id            = module.vpc.vpc_id
  subnet_id         = [
    module.vpc.subnet_priv_a_id,
    module.vpc.subnet_priv_b_id,
    module.vpc.subnet_priv_c_id
  ]

  root_block_device = [{
    volume_type = "gp3"
    volume_size = 16
    iops        = 3000
  }]

  # custom inputs 
  ec2_ebs_volume = [
    {
      device_name = "/dev/xvdb"
      type = "gp2"
      size = 8
    },
    {
      device_name = "/dev/xvdc"
      type = "gp2"
      size = 16
    },
        {
      device_name = "/dev/xvdd"
      type = "gp2"
      size = 32
    }
  ]

  # custom inputs
  ec2_instance_name     = "${var.application_id}TEST"
  ec2_instance_policies = [
    "arn:aws:iam::aws:policy/CloudWatchActionsEC2Access",
    "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
  ]

  # defining tags
  tags = merge(
    local.commons,
    local.ec2,
    local.backup,
  )
}

```