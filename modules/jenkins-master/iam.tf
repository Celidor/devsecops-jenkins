resource "aws_iam_instance_profile" "jenkins_server" {
  name = "jenkins-server-profile"
  role = "${aws_iam_role.jenkins_server.name}"

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_iam_role" "jenkins_server" {
  name = "jenkins-server-role"
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

resource "aws_iam_policy_attachment" "jenkins_server_s3" {
  name       = "AmazonS3FullAccess"
  roles      = ["${aws_iam_role.jenkins_server.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "jenkins_server_route53" {
  name       = "AmazonRoute53FullAccess"
  roles      = ["${aws_iam_role.jenkins_server.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_policy_attachment" "jenkins_server_cloudfront" {
  name       = "CloudFrontFullAccess"
  roles      = ["${aws_iam_role.jenkins_server.name}"]
  policy_arn = "arn:aws:iam::aws:policy/CloudFrontFullAccess"
}

resource "aws_iam_policy_attachment" "jenkins_server_api_gateway" {
  name       = "AmazonAPIGatewayAdministrator"
  roles      = ["${aws_iam_role.jenkins_server.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
}

resource "aws_iam_policy_attachment" "jenkins_server_certificate_manager" {
  name       = "AWSCertificateManagerFullAccess"
  roles      = ["${aws_iam_role.jenkins_server.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess"
}

resource "aws_iam_policy_attachment" "jenkins_server_lambda" {
  name       = "AWSLambdaFullAccess"
  roles      = ["${aws_iam_role.jenkins_server.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
}

resource "aws_iam_policy_attachment" "jenkins_server_cloudwatch" {
  name       = "CloudWatchFullAccess"
  roles      = ["${aws_iam_role.jenkins_server.name}"]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_policy_attachment" "jenkins_server_cloudformation" {
  name       = "CloudFormationFullAccess"
  roles      = ["${aws_iam_role.jenkins_server.name}"]
  policy_arn = "${aws_iam_policy.server_cloudformation_policy.arn}"
}

resource "aws_iam_policy" "server_cloudformation_policy" {
  name        = "Jenkins-server-cloudformation-policy"
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
