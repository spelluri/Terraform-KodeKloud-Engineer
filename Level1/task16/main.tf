resource "aws_iam_policy" "iampolicy_jim" {
    name = "iampolicy_jim"
    path = "/"
    description = "IAM policy for Jim to allow EC2 read-only access"

    policy = jsonencode({
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "ec2:Describe*",
      ]
      "Resource" : "*"
    }
]
})
}