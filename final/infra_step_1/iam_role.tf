data "aws_iam_policy_document" "assume_role" {
    provider = aws.net
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
    provider = aws.net
  name               = "test-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "policy" {
    provider = aws.net
  statement {
    effect    = "Allow"
    actions   = ["ec2:*", "s3:*", "rds:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
    provider = aws.net
  name        = "test-policy"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "test-attach" {
    provider = aws.net
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
resource "aws_iam_instance_profile" "test_profile" {
    provider = aws.net
  name = "test_profile"
  role = aws_iam_role.role.name
}