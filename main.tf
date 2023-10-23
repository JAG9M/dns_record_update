provider "aws" {
  region = "us-east-1"

}
resource "aws_iam_role" "jenkins_route53_role" {
  name = "JenkinsRoute53Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com" #if jenkins runs on eks
        }
      }
    ]
  })

}
#Define a policy that includes permissions for Route 53
data "aws_iam_policy_document" "route53_policy" {
  statement {
    actions   = ["route53:ChangeResourceRecordSets", "route53:ListResourceRecordSets"]
    resources = ["*"]
  }
}
#Create an IAM policy
resource "aws_iam_policy" "jenkins_route53_policy" {
  name        = "JenkinsRoute53Policy"
  description = "Policy for Jenkins to interact with Route 53"
  policy      = data.aws_iam_policy_document.route53_policy.json

}
# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "jenkins_route53_policy_attachment" {
  policy_arn = aws_iam_policy.jenkins_route53_policy.arn
  role       = aws_iam_role.jenkins_route53_role.name

}
