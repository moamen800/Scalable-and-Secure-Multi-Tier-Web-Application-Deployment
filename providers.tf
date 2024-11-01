# Configure the AWS provider with region and profile
provider "aws" {
  region  = var.aws_region  # AWS region (us-east-1)
  profile = var.aws_profile # AWS CLI profile to use for authentication
}
