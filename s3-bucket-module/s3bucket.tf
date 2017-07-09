resource "aws_s3_bucket" "hackforward_bucket" {
  bucket = "${var.aws_account}-${var.s3_bucket_name}"
  acl = "${var.s3_bucket_acl}"
  force_destroy = "${var.aws_force_destroy}"
  versioning = {
    enabled="${var.bucket_versioning}"
  }
  tags = {
    owner = "Jayaprakash Reddy"
    email = "jayaprakash.jp63@gmail.com"
    environment = "prod"
  }
  region = "${var.s3_aws_region}"
}

output "bucket_id" {
  value="${aws_s3_bucket.hackforward_bucket.id}"
}
