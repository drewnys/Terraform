# Default variable assignment file (.tfvars)
# Terraform will automatically look for this file name to assign already declared variables
# Base Types [string, number, bool]
# Complex Types [list, set, map, object, tuple]

region              = "us-east-2"
access_key          = "********************"
secret_key          = "********************"
# assume_role = "arn:aws:iam::123456789101112:role/Terraform_Admin"
example_string_list = ["us-east-1", "us-east-2", "us-west-1", "us-west-2"]
port                = 3000
