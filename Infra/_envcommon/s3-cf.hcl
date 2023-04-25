# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for vpc. The common variables for each environment to
# deploy vpc are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment

  # Automatically load aws-level variables
  aws_vars = read_terragrunt_config(find_in_parent_folders("../region.hcl"))

  # Extract out common variables for reuse
  aws_region = local.aws_vars.locals.aws_region

}


# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  project_prefix = "healthlink"
  env            = local.env
  aws_region     = local.aws_region

  tags = {
    Terraform   = "true"
    Environment = local.env
  }

  # TODO: To avoid storing your DB password in the code, set it as the environment variable TF_VAR_master_password
}
