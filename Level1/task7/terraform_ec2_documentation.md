# Terraform EC2 Instance Task Documentation

This document captures the details and steps for creating an EC2 instance using Terraform as part of the Nautilus incremental migration strategy.

---

## Task Overview

The Nautilus DevOps team is migrating part of their infrastructure to AWS in incremental steps. As part of this, a task was to provision an EC2 instance with specific requirements using Terraform.

### Requirements

* **EC2 Name tag**: `xfusion-ec2` (defines the instance name in AWS)
* **AMI**: `ami-0c101f26f147fa7fd` (Amazon Linux)
* **Instance type**: `t2.micro`
* **RSA key pair**: `xfusion-kp`
* **Security group**: default AWS security group
* **Terraform working directory**: `/home/bob/terraform`
* **File**: `main.tf` (do not create a separate `.tf` file)

### Notes

* The key pair should be generated locally before running Terraform commands. Terraform **does not generate the private key**; it only uploads the **public key** to AWS.
* Default security group is automatically attached by AWS if no security group is explicitly specified.

---

## Terraform Implementation

1. **Generate the RSA key locally before running Terraform**:

```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/xfusion-kp -N ""
```

This creates:

* `xfusion-kp` → private key (stay safe locally)
* `xfusion-kp.pub` → public key (used in Terraform)

2. **Terraform `main.tf`**:

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "xfusion_kp" {
  key_name   = "xfusion-kp"
  public_key = file("~/.ssh/xfusion-kp.pub")
}

resource "aws_instance" "xfusion_ec2" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.xfusion_kp.key_name

  tags = {
    Name = "xfusion-ec2"
  }
}
```

3. **Deploy**:

```bash
cd /home/bob/terraform
terraform init
terraform apply -auto-approve
```

---

## Key Notes

* The `aws_key_pair` resource **does not generate a new key pair**; it only registers the provided public key in AWS. This ensures that private keys remain secure and are **never stored in Terraform state**.
* You must generate the key pair locally **before running Terraform**, otherwise the `aws_key_pair` resource will fail.
* The EC2 instance **implicitly uses the default security group** if none is specified.
* Terraform requires **resource references** to avoid the `'not used'` error, e.g., use `aws_key_pair.xfusion_kp.key_name` instead of a string.
* Managing SSH keys at scale can be cumbersome; modern DevOps practices recommend AWS SSM Session Manager or EC2 Instance Connect.

---

