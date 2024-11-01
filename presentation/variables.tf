####################################### S3 Bucket Name Variable #######################################
variable "s3_bucket_name" {
  description = "S3 bucket name for the frontend"
  type        = string
  default     = "frontendbucket1381438414141814"
}

####################################### AWS Region Variable #######################################
variable "aws_region" {
  description = "AWS region for resource deployment"
}
