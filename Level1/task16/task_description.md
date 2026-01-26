# Terraform Task Documentation: AWS IAM Policy Creation (Nautilus DevOps)

## 📌 Task Overview

The Nautilus DevOps team is configuring AWS IAM policies as part of cloud migration. IAM policies define **permissions for users, groups, and roles**. This document focuses on creating an **EC2 read-only IAM policy** using Terraform.

---

## 🎯 Task Objective

Create an IAM policy named:

```
iampolicy_jim
```

* **Region**: us-east-1
* **Purpose**: Allow users to view all EC2 instances, AMIs, and snapshots in the Amazon EC2 console (read-only)
* **Terraform working directory**: `/home/bob/terraform`
* **File**: `main.tf` (do not create other `.tf` files)

---

## 🛠 Terraform Configuration

### Minimal Read-Only EC2 Policy

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_policy" "jim_policy" {
  name        = "iampolicy_jim"
  description = "Read-only access to EC2 instances, AMIs, and snapshots"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:Describe*"]
        Resource = "*"
      }
    ]
  })
}
```

### Optional Full EC2 Console Access Policy

```hcl
data "aws_iam_policy_document" "ec2_readonly_full" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "ec2:GetSecurityGroupsForVpc",
      "elasticloadbalancing:Describe*",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:Describe*",
      "autoscaling:Describe*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "jim_policy" {
  name   = "iampolicy_jim"
  policy = data.aws_iam_policy_document.ec2_readonly_full.json
}
```

### Explanation

* **Minimal policy**: `ec2:Describe*` covers core EC2 read-only operations (instances, AMIs, snapshots)
* **Full console policy**: Adds ELB, CloudWatch, and Auto Scaling for complete console visibility
* **Terraform data source** `aws_iam_policy_document` helps create JSON programmatically

---

## 🔍 Verification Without Console

* Terraform state:

```bash
terraform state list
terraform state show aws_iam_policy.jim_policy
```

* Terraform plan: ensure no pending changes
* AWS CLI (if read access exists):

```bash
aws iam get-policy --policy-arn <policy-arn>
```

---

## 🧠 DevOps Best Practices

* Don’t memorize IAM JSON; use AWS managed policies and Terraform examples
* Minimal permissions are safer and easier to maintain
* Service-specific read-only policies preferred over global `ReadOnlyAccess`
* Terraform state is the source of truth in environments without console access

---

## ⭐ Key Takeaways

* **IAM Read-Only vs EC2 Read-Only**:

  * IAM Read-Only → `iam:Get*`, `iam:List*` (IAM visibility only)
  * EC2 Read-Only → `ec2:Describe*` (view instances, AMIs, snapshots)
* Terraform allows **full policy automation**, minimal or full console access
* Reusable patterns can be stored in GitHub for future use

---

