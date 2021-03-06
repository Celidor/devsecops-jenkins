resource "aws_iam_instance_profile" "jenkins_server" {
  name = "jenkins-${terraform.workspace}-server-profile"
  role = "${aws_iam_role.jenkins_server.name}"
}

resource "aws_iam_role" "jenkins_server" {
  name = "jenkins-server-${terraform.workspace}-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "jenkins_server_s3" {
  role       = "${aws_iam_role.jenkins_server.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "jenkins_server_route53" {
  role       = "${aws_iam_role.jenkins_server.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_role_policy_attachment" "jenkins_server_cloudfront" {
  role       = "${aws_iam_role.jenkins_server.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudFrontFullAccess"
}

resource "aws_iam_role_policy_attachment" "jenkins_server_api_gateway" {
  role       = "${aws_iam_role.jenkins_server.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
}

resource "aws_iam_role_policy_attachment" "jenkins_server_certificate_manager" {
  role       = "${aws_iam_role.jenkins_server.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess"
}

resource "aws_iam_role_policy_attachment" "jenkins_server_lambda" {
  role       = "${aws_iam_role.jenkins_server.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
}

resource "aws_iam_role_policy_attachment" "jenkins_server_cloudwatch" {
  role       = "${aws_iam_role.jenkins_server.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "jenkins_server_cloudformation" {
  role       = "${aws_iam_role.jenkins_server.name}"
  policy_arn = "${aws_iam_policy.server_cloudformation_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "jenkins_server_iam" {
  role       = "${aws_iam_role.jenkins_server.name}"
  policy_arn = "${aws_iam_policy.server_iam_policy.arn}"
}

resource "aws_iam_policy" "server_cloudformation_policy" {
  name        = "jenkins-${terraform.workspace}-cloudformation-policy"
  path        = "/"
  description = "Allows Jenkins to create CloudFormation templates"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement":[
     {
      "Effect": "Allow",
      "Action": [
          "cloudformation:*"
          ],
      "Resource": "*"
     }
   ]
}
EOF
}

resource "aws_iam_policy" "server_iam_policy" {
  name        = "jenkins-${terraform.workspace}-iam-policy"
  path        = "/"
  description = "Allows Jenkins to create IAM roles"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement":[
     {
      "Effect": "Allow",
      "Action": [
          "iam:CreateRole",
          "iam:CreateServiceLinkedRole",
          "iam:DeleteRolePolicy",
          "iam:PutRolePolicy",
          "iam:PutRolePolicy"
      ],
      "Resource": "*"
     }
   ]
}
EOF
}
