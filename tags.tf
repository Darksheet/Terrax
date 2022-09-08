# defining mandatory tags
locals {
  commons = {
    Application = upper(var.application_id)
    Domain      = upper(var.domain_account)
    Environment = upper(terraform.workspace)
  }
  backup = {
    Backup          = lookup(var.backup_plan, terraform.workspace)
  }
}
 