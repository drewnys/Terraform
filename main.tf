terraform {
  required_version = ">= 1.2.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.26.0"
    }
  }
}

#region Provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
#   assume_role {
#     role_arn = "arn:aws:iam::296630729054:role/Terraform_Admin"
#   }
}

#endregion

#region Variables
variable "region" {
  description = "AWS Region to Deploy"
  default     = "us-east-2"
  type        = string # Base Types [string, number, bool]
  validation {         # length validation
    condition     = length(var.region) == 9
    error_message = "VALIDATION: Invalid Region Length"
  }
}

variable "port" {
  description = "Port"
  type        = number
  validation { # REGEX validation
    condition     = can(regex("8080|80|3000", var.port))
    error_message = "VALIDATION: Invalid Port Number"
  }
}

variable "access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true # Do not display during terraform plan and apply
}

variable "secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "example_string_list" {
  description = "Example List of Strings"
  type        = list(string) # Complex Types [list, set, map, object, tuple]
  default     = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
}

variable "latest_comment_input" {
  description = "Demonstrates a variable with no default or entry in tfvars"
  type        = string # Do not need to specify base type
  validation {         # length validation (AWS max key length 127 | max value length 255)
    condition     = length(var.latest_comment_input) <= 254
    error_message = "VALIDATION: Invalid AWS Tag Length"
  }
  # Can also pass this with the terriform apply -var variable_name=X
}

variable "rules" { #dynamic block variable
  default = [
    {
      port        = 80
      proto       = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      port        = 22
      proto       = "tcp"
      cidr_blocks = "1.2.3.4/32"
    },
  ]
}

variable "colleagues" {
  type = object({
    name = string
    role = string
  })
  default = {
    name = "Drew"
    role = "newbie"
  }
}

#endregion

#region Outputs
output "example_output" {
  description = "Example Output"
  value       = join("***", [tostring(var.region), "Random Arbitrary Text"]) # Example of join function
}

output "example_output_sensative" {
  description = "Example Output"
  value       = "example_output"
  sensitive   = true
}

output "Terraform_AWS_Provider" {
  description = "Link to the Terraform AWS Provider documentation"
  value       = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs"
}
output "Terraform_Functions" {
  description = "Link to the Terraform Function documentation" # Can use terraform console command to test out functions
  value       = "https://www.terraform.io/language/functions"
}

output "Terraform_Workspace" { # output the current workspace (initial = default)
  description = "Current Workspace"
  value       = terraform.workspace
}
#endregion




#region Infrastructure as Code (IaC)

#EXAMPLE - AWS S3
resource "aws_s3_bucket" "terraformS3" {
  bucket = "drewnys-learn-terraform"

  tags = {
    Name          = "My Terraform S3 Bucket"
    Environment   = terraform.workspace == "default" ? "DEV" : "PROD" # conditional example
    LatestComment = var.latest_comment_input
  }
}

#EXAMPLE - DynamoDB
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "drewnys-learn-terraform"
  billing_mode   = "PROVISIONED" # This is required - options [PROVISIONED, PAY_PER_REQUEST]
  read_capacity  = 5             # Must be >= 1
  write_capacity = 5             # Must be >= 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name          = "My Terraform DynamoDB"
    Environment   = terraform.workspace == "default" ? "DEV" : "PROD"
    LatestComment = var.latest_comment_input
  }
}

#endregion