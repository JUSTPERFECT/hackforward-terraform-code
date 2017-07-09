variable "s3_bucket_name" {}
variable "s3_bucket_acl" {
  type="string"
  default="public-read"
}
variable "bucket_versioning" {
  default = "false"
}
variable "s3_aws_region" {
  type="string"
}
variable "aws_force_destroy" {
  default = "true"
}
variable "aws_account" {
  type = "string"
  description = "Account name"
}
