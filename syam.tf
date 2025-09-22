resource "aws_iam_user" "jenkins" {
  name = "jenkins-deployer"
}

resource "aws_iam_access_key" "jenkins_key" {
  user = aws_iam_user.jenkins.name
}

data "aws_iam_policy_document" "jenkins_policy" {
  statement {
    sid = "S3FullAccessForSite"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${var.site_bucket_name}",
      "arn:aws:s3:::${var.site_bucket_name}/*",
    ]
  }

  statement {
    sid = "CloudFrontInvalidation"
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
    ]
    resources = ["*"]
  }

  statement {
    sid = "Route53Change"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]
    resources = ["*"]
  }

  # If Terraform will create resources that require broader permissions, add them here.
}

resource "aws_iam_policy" "jenkins_policy" {
  name   = "jenkins-deployer-policy"
  policy = data.aws_iam_policy_document.jenkins_policy.json
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.jenkins.name
  policy_arn = aws_iam_policy.jenkins_policy.arn
}

output "jenkins_access_key_id" {
  value       = aws_iam_access_key.jenkins_key.id
  description = "Access key id for Jenkins user (store securely)"
}

output "jenkins_secret_access_key" {
  value       = aws_iam_access_key.jenkins_key.secret
  description = "Secret key for Jenkins user (store securely). Rotate/delete after use."
  sensitive   = true
}
