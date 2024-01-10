# Attach IAM policy to allow S3 access (adjust policy as needed)
data "aws_iam_policy" "s3_access_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "demo_ec2_role_attachment" {
  policy_arn = data.aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.demo_ec2_role.name
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "demo_ec2_instance_profile" {
  name = "demo-ec2-instance-profile"
  role = aws_iam_role.demo_ec2_role.name
}