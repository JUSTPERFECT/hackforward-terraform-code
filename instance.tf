##bucket creation

module "s3_bucket_for_code" {
  source = "./s3-bucket-module"
  s3_bucket_name = "${var.S3_BUCKET_NAME}"
  s3_aws_region = "${var.AWS_REGION}"
  aws_account = "${var.AWS_ACCOUNT}"
}

#bcket policy

resource "aws_s3_bucket_policy" "code_bucket_policy" {
  bucket = "${module.s3_bucket_for_code.bucket_id}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
       {
           "Sid": "MakeItPublic",
           "Effect": "Allow",
           "Principal": "*",
           "Action": "s3:GetObject",
           "Resource": "arn:aws:s3:::${module.s3_bucket_for_code.bucket_id}/*"
       },
        {
               "Sid": "DenyIncorrectEncryptionHeader",
               "Effect": "Deny",
               "Principal": "*",
               "Action": "s3:PutObject",
               "Resource": "arn:aws:s3:::${module.s3_bucket_for_code.bucket_id}/*",
               "Condition": {
                       "StringNotEquals": {
                              "s3:x-amz-server-side-encryption": "AES256"
                        }
               }
          },
          {
               "Sid": "DenyUnEncryptedObjectUploads",
               "Effect": "Deny",
               "Principal": "*",
               "Action": "s3:PutObject",
               "Resource": "arn:aws:s3:::${module.s3_bucket_for_code.bucket_id}/*",
               "Condition": {
                       "Null": {
                              "s3:x-amz-server-side-encryption": true
                       }
              }
          }
    ]
}
POLICY
}
