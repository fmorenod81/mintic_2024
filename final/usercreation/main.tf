#### SECTION 1: CREATE USERS
resource "aws_iam_user" "l1user" {
  name = "APP"

  tags = {
    creator = "APP"
    description = "User to update EC2 Instance Only"
  }
}
resource "aws_iam_user" "l2user" {
  name = "DBA"

  tags = {
    creator = "DBA"
    description = "User to create RDS and its related actions/Quicksight"
  }
}
resource "aws_iam_user" "l3user" {
  name = "NET"

  tags = {
    creator = "NET"
    description = "User to create net infrastructure and backup"
  }
}
#### SECTION 2: CREATE ACESS KEYS
resource "aws_iam_access_key" "l1user_access_key" {
  user = aws_iam_user.l1user.name
}
resource "aws_iam_access_key" "l2user_access_key" {
  user = aws_iam_user.l2user.name
}
resource "aws_iam_access_key" "l3user_access_key" {
  user = aws_iam_user.l3user.name
}
locals {
  l1user_keys_csv = "access_key,secret_key\n${aws_iam_access_key.l1user_access_key.id},${aws_iam_access_key.l1user_access_key.secret}"
  l2user_keys_csv = "access_key,secret_key\n${aws_iam_access_key.l2user_access_key.id},${aws_iam_access_key.l2user_access_key.secret}"
  l3user_keys_csv = "access_key,secret_key\n${aws_iam_access_key.l3user_access_key.id},${aws_iam_access_key.l3user_access_key.secret}"
}
resource "local_file" "appuser_keys" {
  content  = local.l1user_keys_csv
  filename = "app-keys.csv"
}
resource "local_file" "dbauser_keys" {
  content  = local.l2user_keys_csv
  filename = "dba-keys.csv"
}
resource "local_file" "netuser_keys" {
  content  = local.l3user_keys_csv
  filename = "net-keys.csv"
}
#### SECTION 3: CREATE PERMISSIONS AND POLICIES
data "aws_iam_policy_document" "actionsforL1group" {
  statement {
    actions = [
    "ec2:DescribeInstances",
    "ec2:DescribeInstanceStatus",
    "ec2:RunInstances",
    "ec2:StartInstances",
    "ec2:StopInstances",
    "ec2:RebootInstances",
    "ec2:DescribeImages",
    "ec2:*",
    "iam:PassRole"
    ]

    resources = [
      "*",
    ]
  }
}
data "aws_iam_policy_document" "actionsforL2group" {
  statement {
    actions = [
    "rds:*",
    "ec2:DescribeInstances",
    "ec2:CreateTags",
    "ec2:DescribeTags",
    "ec2:DescribeInstanceTypes",
    "ec2:DescribeInstanceAttribute",
    "ec2:DescribeVolumes",
    "ec2:DescribeInstanceCreditSpecifications",
    "ec2:DescribeImages",
    "ec2:RunInstances",
    "ec2:StartInstances",
    "ec2:StopInstances",
    "ec2:RebootInstances",
    "ec2:TerminateInstances",
    "ec2:DescribeVpcs",
    "ec2:DescribeSecurityGroups",
    "ec2:DescribeAddresses",
    "ec2:AssociateAddress",
    "ec2:DisassociateAddress",
    "ec2:DisassociateVpcCidrBlock",
    "ec2:GetSecurityGroupsForVpc",
    "ec2:ModifySecurityGroupRules",
    "ec2:RevokeSecurityGroupEgress",
    "ec2:RevokeSecurityGroupIngress",
    "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
    "ec2:UpdateSecurityGroupRuleDescriptionsIngress"
    ]
    resources = [
      "*",
    ]
  }
}
data "aws_iam_policy_document" "actionsforL3group" {
  statement {
    actions = [
    "ec2:*",
    "iam:*",
    "s3:*"
    ]
    resources = [
      "*",
    ]
  }
}
resource "aws_iam_policy" "policyforL1group" {
  name        = "policyforL1group"
  policy      = data.aws_iam_policy_document.actionsforL1group.json
}
resource "aws_iam_policy" "policyforL2group" {
  name        = "policyforL2group"
  policy      = data.aws_iam_policy_document.actionsforL2group.json
}
resource "aws_iam_policy" "policyforL3group" {
  name        = "policyforL3group"
  policy      = data.aws_iam_policy_document.actionsforL3group.json
}
#### SECTION 4: CREATE GROUPS AND ASSIGN POLICIES AND USERS
resource "aws_iam_group" "l1group" {
  name = "Tecnicos-EC2-L1"
}
resource "aws_iam_group_policy_attachment" "l1group-attach" {
  group      = aws_iam_group.l1group.name
  policy_arn = aws_iam_policy.policyforL1group.arn
}
resource "aws_iam_group_membership" "l1user_membership" {
  name = aws_iam_user.l1user.name
  users = [aws_iam_user.l1user.name]
  group = aws_iam_group.l1group.name
}
resource "aws_iam_group" "l2group" {
  name = "Tecnicos-EC2-L2"
}
resource "aws_iam_group_policy_attachment" "l2group-attach" {
  group      = aws_iam_group.l2group.name
  policy_arn = aws_iam_policy.policyforL2group.arn
}
resource "aws_iam_group_membership" "l2user_membership" {
  name = aws_iam_user.l2user.name
  users = [aws_iam_user.l2user.name]
  group = aws_iam_group.l2group.name
}
resource "aws_iam_group" "l3group" {
  name = "Tecnicos-EC2-L3"
}
resource "aws_iam_group_policy_attachment" "l3group-attach" {
  group      = aws_iam_group.l3group.name
  policy_arn = aws_iam_policy.policyforL3group.arn
}
resource "aws_iam_group_membership" "l3user_membership" {
  name = aws_iam_user.l3user.name
  users = [aws_iam_user.l3user.name]
  group = aws_iam_group.l3group.name
}
