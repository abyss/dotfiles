# TFLint Rules for Root Module / Project

config {
  module = true # Module Inspection
}

plugin "aws" {
  enabled = true
  version = "0.11.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Disallow deprecated (0.11-style) interpolation
rule "terraform_deprecated_interpolation" {
  enabled = true
}

# Disallow legacy dot index syntax
rule "terraform_deprecated_index" {
  enabled = true
}

# Disallow variables, data sources, and locals that are declared but never used
rule "terraform_unused_declarations" {
  enabled = true
}

# Disallow `//` comments in favor of `#`
rule "terraform_comment_syntax" {
  enabled = true
}

# Disallow `output` declarations without description
rule "terraform_documented_outputs" {
  enabled = true
}

# Disallow `variable` declarations without description
rule "terraform_typed_variables" {
  enabled = true
}

# Disallow specifying a git or mercurial repository as a module source without pinning to a version
rule "terraform_module_pinned_source" {
  enabled = true
}

# Disallow `terraform` declarations without require_version
rule "terraform_required_version" {
  enabled = true
}

# Require that all providers have version constraints through required_providers
rule "terraform_required_providers" {
  enabled = true
}

# Check that all `required_providers` are used in the module
rule "terraform_unused_required_providers" {
  enabled = true
}

# Ensure that a module complies with the Terraform Standard Module Structure
rule "terraform_standard_module_structure" {
  enabled = false
}

# terraform.workspace should not be used with a "remote" backend with remote execution
rule "terraform_workspace_remote" {
  enabled = true
}
