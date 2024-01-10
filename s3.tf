# Create S3 Bucket
resource "aws_s3_bucket" "demo_s3_bucket" {
#   bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name = "Demo Bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "demo_s3_ownership" {
  bucket = aws_s3_bucket.demo_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "demo_s3_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.demo_s3_ownership]

  bucket = aws_s3_bucket.demo_s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "demo_s3_policy" {
  bucket = aws_s3_bucket.demo_s3_bucket.id
  policy = data.aws_iam_policy_document.demo_s3_policy_document.json
}

data "aws_iam_policy_document" "demo_s3_policy_document" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.demo_ec2_role.arn}"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.demo_s3_bucket.arn,
      "${aws_s3_bucket.demo_s3_bucket.arn}/*",
    ]
  }
}