####################################### Module Definitions #######################################
# This section defines the infrastructure modules for different layers of the multi-tier architecture.
# Each module is isolated for modularity and reusability. Dependencies between modules ensure the correct
# deployment order.

####################################### Network Module #######################################
# The network module sets up the VPC, subnets, and networking components required for the application.
module "network" {
  source = "./network" # Path to the network module directory
}

####################################### Presentation Module #######################################
# The presentation module handles the frontend infrastructure, including S3, CloudFront, and Cognito.
# It depends on the network module to ensure that networking resources are available before deployment.
module "presentation" {
  source = "./presentation" # Path to the presentation module directory
  aws_region = var.aws_region
}

####################################### Business Logic Module #######################################
# The business logic module configures API Gateway and Lambda functions to handle requests.
# It depends on the presentation module to ensure frontend resources are available before deploying backend services.
module "business-logic" {
  source = "./business-logic" # Path to the business logic module directory
}

####################################### Data Module #######################################
# The data module manages DynamoDB and other data storage solutions.
# It depends on the business logic module to ensure that backend services are ready before deploying the database layer.
module "data" {
  source = "./data" # Path to the data module directory
}
