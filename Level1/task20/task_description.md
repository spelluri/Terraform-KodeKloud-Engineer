# AWS SSM Parameter Creation using Terraform

## Task Overview

The Nautilus DevOps team needs to create an AWS Systems Manager (SSM) Parameter to store configuration or secrets that can be accessed by AWS services and applications. The parameter will serve as a centralized, secure, and versioned store for configuration and operational data.

This task is implemented using **Terraform** as part of Infrastructure as Code (IaC) practices.

---

## Requirements

* **Service**: AWS Systems Manager (SSM) Parameter Store
* **Parameter Name**: `devops-ssm-parameter`
* **Parameter Type**: `String` (for non-sensitive values) or `SecureString` for secrets
* **Parameter Value**: `devops-value`
* **Region**: `us-east-1`
* **Terraform Working Directory**: `/home/bob/terraform`
* **Terraform File**: `main.tf` only (no additional `.tf` files)
* **Validation**: `terraform plan` must return *No changes. Your infrastructure matches the configuration.*

---

## Terraform Configuration (`main.tf`)

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_ssm_parameter" "devops_parameter" {
  name  = "devops-ssm-parameter"
  type  = "String"
  value = "devops-value"
}
```

> For sensitive secrets (like access keys), use `type = "SecureString"` and optionally specify a KMS key for encryption.

---

## Explanation of Terraform Arguments

* **provider.aws.region**: Specifies AWS region (`us-east-1`) for the parameter
* **aws_ssm_parameter**: Terraform resource to create an SSM parameter
* **name**: Unique identifier in Parameter Store (`devops-ssm-parameter`)
* **type**: `String` for normal values, `SecureString` for secrets
* **value**: Actual value stored in Parameter Store (`devops-value`)

---

## Deployment Steps

1. Open VS Code
2. Navigate to `/home/bob/terraform`
3. Right-click in Explorer → **Open in Integrated Terminal**
4. Run Terraform commands:

```bash
terraform init
terraform apply
```

* Approve apply with `yes`
* Verify using:

```bash
terraform plan
```

Expected output: `No changes. Your infrastructure matches the configuration.`

To retrieve the parameter using AWS CLI:

```bash
aws ssm get-parameter --name "devops-ssm-parameter" --region us-east-1
```

---

## AWS SSM Full Form

**SSM = Systems Manager**

* AWS Systems Manager provides centralized operational control and management of infrastructure.
* **Parameter Store** is a component of SSM for storing configuration, secrets, and operational data securely.

---

## Real-Life Use Cases of SSM

1. **Centralized Configuration Management**

   * Store database endpoints, API URLs, feature flags, etc.
   * Applications fetch parameters at runtime instead of hardcoding.

2. **Secure Secret Storage**

   * Store database passwords, API keys, or access tokens using `SecureString`.
   * Integrated with IAM for access control.

3. **Automation & Orchestration**

   * Run commands remotely on EC2 without SSH using **SSM Run Command**.
   * Automate patching, credential rotation, or service restarts using **SSM Automation Documents**.

4. **Parameterized Deployments**

   * Terraform or CloudFormation can dynamically retrieve parameters for resource configuration.

5. **Event-Driven Workflows**

   * CloudWatch alarms trigger SSM Automation Documents for automatic remediation.
   * Auto-scaling EC2 instances fetch parameters during initialization.

6. **Versioning and Auditing**

   * Parameters are versioned automatically, enabling rollback if needed.

### Real-Life Examples

| Scenario           | Example                                                                    |
| ------------------ | -------------------------------------------------------------------------- |
| Application config | Multi-region DB endpoints retrieved dynamically by SaaS applications       |
| Secrets            | Fintech storing API keys with automatic rotation in SecureString           |
| Patch management   | E-commerce company updating thousands of EC2 instances via SSM Run Command |
| Automation         | DevOps team resets failed EC2 instances automatically using SSM Automation |

---

## Best Practices

* Use **SecureString** for sensitive values.
* Assign minimal IAM permissions to access parameters.
* Prefer **IAM roles** for EC2 instances instead of static access keys.
* Use parameter versioning to track changes and allow rollback.
* Integrate SSM with other services for automated, event-driven workflows.

---

## Key Takeaway

> AWS SSM Parameter Store allows centralized, secure, and versioned storage of configuration and secrets. Terraform ensures the parameter is managed consistently, and AWS services can retrieve these parameters for automation, configuration, or secret management.

---


