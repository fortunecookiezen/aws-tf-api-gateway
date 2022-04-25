data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
variable "name" {
  type = string
}
variable "target_loadbalancer" {
  type = string
}
variable "uri" {
  type = string
}
locals {
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}
