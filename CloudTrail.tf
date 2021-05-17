data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "awss3bucketloggroups" {
  name = "s3-bucketlog-group"
}

resource "aws_cloudtrail" "awscloudtrailcqpocs" {
  name                          = "tf-based-cloud-trail"
  s3_bucket_name                = aws_s3_bucket.cqpocs.id
  s3_key_prefix                 = "cloudtrailkey"
  include_global_service_events = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.awss3bucketloggroups.arn}:*" # CloudTrail requires the Log Stream wildcard
}

resource "aws_s3_bucket" "cqpocs" {
  bucket        = "tf-test-trail-bucket-cqpocs"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::tf-test-trail-bucket-cqpocs"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::tf-test-trail-bucket-cqpocs/cloudtrailkey/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}