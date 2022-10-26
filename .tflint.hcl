# TFLint Rules for Root Module / Project
# See rule details here: https://github.com/terraform-linters/tflint/tree/master/docs/rules

config {
  module = true # Module Inspection
}

plugin "terraform" {
  enabled = true

  preset = "all"
}

plugin "aws" {
  enabled = true
  version = "0.18.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Enforces naming conventions
rule "terraform_naming_convention" {
  enabled = false
}

# Ensure that a module complies with the Terraform Standard Module Structure
rule "terraform_standard_module_structure" {
  enabled = false
}
