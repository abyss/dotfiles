# TFLint Rules for Root Module / Project
config {
  call_module_type = "all" # Module inspection
  format = "compact"
}

# See Terraform Ruleset here:
# https://github.com/terraform-linters/tflint-ruleset-terraform/tree/main/docs/rules/
plugin "terraform" {
  enabled = true
  preset  = "all"
}

# Enforces naming conventions
# Disabled because we don't follow it in most projects
rule "terraform_naming_convention" {
  enabled = false
}

# Ensure that a module complies with the Terraform Standard Module Structure
# Disabled because while it's a good recommendation, it doesn't always fit the need
rule "terraform_standard_module_structure" {
  enabled = false
}

# See AWS Ruleset here:
# https://github.com/terraform-linters/tflint-ruleset-aws/blob/master/docs/rules/
plugin "aws" {
  enabled = true
  version = "0.30.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
