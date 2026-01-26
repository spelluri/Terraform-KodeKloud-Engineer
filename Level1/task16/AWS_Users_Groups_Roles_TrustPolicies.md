AWS IAM Concepts & Best Practices – GitHub Documentation
1️⃣ IAM Users

Represents an individual human or service principal in AWS.

Can have permanent credentials (passwords, access keys).

Can be added to groups for easier permission management.

Example (Terraform):

resource "aws_iam_user" "alice" {
  name = "alice"
}

resource "aws_iam_user" "bob" {
  name = "bob"
}

2️⃣ IAM Groups

A collection of IAM users.

Cannot have credentials or assume roles directly.

Policies attached to a group are inherited by all users in the group.

Example (Terraform):

resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group_membership" "dev_group" {
  group = aws_iam_group.developers.name
  users = [aws_iam_user.alice.name, aws_iam_user.bob.name]
}

3️⃣ IAM Roles

Temporary identities that can be assumed by:

IAM users

AWS services (EC2, Lambda, ECS, etc.)

External identities (SAML, OIDC, cross-account)

Cannot have permanent credentials.

Permissions come from policies attached to the role.

Trust policy defines who can assume the role.

Terraform Example:

resource "aws_iam_role" "ec2_read_role" {
  name = "EC2ReadRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { AWS = "arn:aws:iam::123456789012:root" },
      Action = "sts:AssumeRole"
    }]
  })
}

4️⃣ IAM Policies

JSON documents that define permissions.

Specify:

Actions → AWS API operations (e.g., s3:GetObject)

Resources → Which AWS resources the action applies to

Effect → Allow or Deny

Can be attached to users, groups, or roles.

Example – S3 Read-Only Policy:

resource "aws_iam_policy" "s3_read_policy" {
  name   = "S3ReadOnly"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = ["s3:GetObject", "s3:ListBucket"],
      Resource = ["arn:aws:s3:::my-bucket", "arn:aws:s3:::my-bucket/*"]
    }]
  })
}

5️⃣ Role-Policy Relationship

Role = identity, Policy = permissions

Attach a policy to a role → defines what the role can do

Role’s trust policy → defines who can assume it

Users or services assume the role → get temporary credentials → act with role permissions

Terraform Example – Attach Policy to Role:

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_read_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

6️⃣ sts:AssumeRole and Groups

Groups cannot assume roles directly

Attach a policy to the group allowing sts:AssumeRole → all group members inherit ability

Role’s trust policy must include the users who should be able to assume it

Users call sts:AssumeRole → receive temporary credentials

Terraform Example – Group Can Assume Role:

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect   = "Allow"
    actions  = ["sts:AssumeRole"]
    resources = [aws_iam_role.ec2_read_role.arn]
  }
}

resource "aws_iam_policy" "assume_ec2_role_policy" {
  name   = "AllowAssumeEC2ReadRole"
  policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_group_policy_attachment" "attach_assume_role" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.assume_ec2_role_policy.arn
}

7️⃣ Policies and API Calls

Policies do not make API calls themselves

Policies define which API calls are allowed or denied

When a user or role tries an AWS API call, IAM evaluates attached policies → allows or denies

8️⃣ Flow Diagram – Users, Group, Role, Policy

Explanation:

Users Alice, Bob, Carol are in group Developers

Group has policy to allow sts:AssumeRole on EC2ReadRole

Users call sts:AssumeRole → receive temporary credentials → act with role permissions

9️⃣ TL;DR

Users → human/service accounts

Groups → manage multiple users efficiently

Roles → temporary identities with policies

Policies → define permissions on actions/resources

sts:AssumeRole → users/groups call this to assume a role

Trust policy → who is allowed to assume a role

Attach policy to group → all users in the group inherit permission to assume the role