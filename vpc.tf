############### PDMZ ACCOUNT VPC ######################


data "aws_vpc" "pdm" {
  tags = {
    Name = "plt102-*-vpc-pdm-001"
  }
}

# data inbound subnet zone a
data "aws_subnet" "inbound-1a" {
  tags = {
    Name = "plt102-*-sub-pdm-inb-1a-001"
  }
}

# data outbound subnet zone a
data "aws_subnet" "outbound-1a" {
  tags = {
    Name = "plt102-*-sub-pdm-oub-1a-001"
  }
}

# data management subnet zone a
data "aws_subnet" "management-1a" {
  tags = {
    Name = "plt102-*-sub-pdm-mgm-1a-001"
  }
}

# data common services subnet zone a
data "aws_subnet" "common-1a" {
  tags = {
    Name = "plt102-*-sub-pdm-cms-1a-001"
  }
}

# data online services subnet zone a
data "aws_subnet" "online-1a" {
  tags = {
    Name = "plt102-*-sub-pdm-onl-1a-001"
  }
}

# data standby services subnet zone a
data "aws_subnet" "standby-1a" {
  tags = {
    Name = "plt102-*-sub-pdm-sta-1a-001"
  }
}





