variable "AWS_REGION" {
  default = "ap-southeast-2"
}
variable "AWS_ACCOUNT" {}
variable "S3_BUCKET_NAME" {}
variable "AWS_AMIS" {
default = {
"ap-southeast-2" = "ami-10918173"
"ap-south-1" = "ami-47205e28"
}
}
variable "INSTANCE_TYPE" {
default = "t2.micro"
}
variable "INSTANCE_ROLE" {}
variable "AWS_KEY_NAME" {}

variable  "AVAILABILITY_ZONES" {
default = "ap-southeast-2a,ap-southeast-2b"
}
variable "ASG_MIN" {
default = "2"
}
variable "ASG_MAX" {
default = "6"
}
variable "ASG_DESIRED" {
default ="2"
}
variable "ZONE_ID" {}
variable "RECORD_SET" {}
