provider "aws" {
  region  = "us-east-1"
}

variable "subnet_cidrs_public" {
  default = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  type = list
}

variable "subnet_cidrs_private" {
  default = ["10.0.70.0/24", "10.0.80.0/24", "10.0.90.0/24"]
  type = list
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
  type = list
}

