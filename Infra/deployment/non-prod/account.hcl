# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "ashwin-non-prod"
  aws_account_id = "487093694530" #TODO: replace me with your AWS account ID!
  aws_profile    = "Ashwin-Non-Prod"
}