provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

terraform {
  experiments = ["provider_default_tags"]
}

provider "aws" {
  alias = "default"
  region = var.aws_region
}
