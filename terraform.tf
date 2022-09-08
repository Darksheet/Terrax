# defining encrypted terraform backend
terraform {
  backend "s3" {
    bucket               = "master-terraform-state"
    workspace_key_prefix = "RENDR002"
    key                  = "terraform_state"
    encrypt              = "true"
    dynamodb_table       = "RENDR002_lock"
    role_arn             = "arn:aws:iam::926914002310:role/rendr002-pdmz-rw-terrax"
  }

}

