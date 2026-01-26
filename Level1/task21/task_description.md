# AWS CloudWatch Logs Setup using Terraform

## Task Overview

The Nautilus DevOps team needs to set up CloudWatch logging for their application. The goal is to create a centralized logging system where application logs can be stored, monitored, and analyzed. This involves creating a **CloudWatch Log Group** and a **Log Stream** using Terraform.

This task is implemented as part of Infrastructure as Code (IaC) practices.

---

## Requirements

* **Service**: Amazon CloudWatch Logs
* **Log Group Name**: `nautilus-log-group`
* **Log Stream Name**: `nautilus-log-stream`
* **Terraform Working Directory**: `/home/bob/terraform`
* **Terraform File**: `main.tf` only (do not create additional `.tf` files)
* **Validation**: Ensure `terraform plan` returns *No changes. Your infrastructure matches the configuration.*

---

## Terraform Configuration (`main.tf`)

```hcl
provider "aws" {
  region = "us-east-1"
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "nautilus_log_group" {
  name              = "nautilus-log-group"
  retention_in_days = 14  # Optional: logs are kept for 14 days
}

# Create CloudWatch Log Stream
resource "aws_cloudwatch_log_stream" "nautilus_log_stream" {
  name           = "nautilus-log-stream"
  log_group_name = aws_cloudwatch_log_group.nautilus_log_group.name
}
```

---

## Explanation of Terraform Arguments

* **aws_cloudwatch_log_group**: Creates a container for logs named `nautilus-log-group`. Retention can be set here.
* **aws_cloudwatch_log_stream**: Creates a sequential channel named `nautilus-log-stream` where the application writes log events.
* **log_group_name**: Associates the stream with its parent log group.

---

## Purpose of CloudWatch Log Group and Log Stream

### Log Group

* A **container for related log streams**.
* Organizes logs from multiple sources.
* Manages retention, tags, and IAM access.
* Example in this task: `nautilus-log-group` collects all logs from the Nautilus application.

### Log Stream

* **Sequential channel for log events** from a single source.
* Each stream belongs to a log group.
* Example in this task: `nautilus-log-stream` receives actual log entries from the application.

### How They Work Together

```
CloudWatch
 └─ Log Group: nautilus-log-group
      ├─ Log Stream: nautilus-log-stream-1 (EC2 instance 1)
      ├─ Log Stream: nautilus-log-stream-2 (EC2 instance 2)
      └─ Log Stream: nautilus-log-stream (main app)
```

* Log Group organizes and manages logs
* Log Stream stores the sequential log data

---

## CloudWatch Logs Functionality

1. **Centralized Logging**: Collect logs from EC2, Lambda, and applications in one place.
2. **Monitoring and Alarming**: Set alarms for specific log patterns or metrics.
3. **Analysis and Insights**: Query logs using CloudWatch Logs Insights.
4. **Persistence and Retention**: Logs can be retained long-term based on log group settings.
5. **Event-Driven Automation**: Logs can trigger Lambda functions, SNS notifications, or SSM Automation documents.

---

## EC2 Integration Notes

* **Default Behavior**: EC2 writes logs to local files (e.g., `/var/log/app.log`).
* **CloudWatch Agent**: Reads local logs and pushes them to the log stream.
* **Local Logs**: CloudWatch does not delete local files by default.
* **Deletion Option**: Use `logrotate` or custom scripts to remove logs after push.
* **Benefit**: Centralized, searchable, and persistent logs without relying solely on EC2 file system.

---

## Deployment Steps

1. Open VS Code and navigate to `/home/bob/terraform`
2. Open Integrated Terminal
3. Run:

```bash
terraform init
terraform apply
```

4. Approve apply with `yes`
5. Verify:

```bash
terraform plan
```

Expected output: `No changes. Your infrastructure matches the configuration.`

---

## Real-Life Examples

| Scenario                  | CloudWatch Use                                                                        |
| ------------------------- | ------------------------------------------------------------------------------------- |
| Application logs from EC2 | Multiple EC2 instances send logs to the same log group, separate streams per instance |
| Lambda monitoring         | Each Lambda function writes logs to its own stream for debugging and monitoring       |
| Security auditing         | Capture VPC Flow Logs or API Gateway logs for analysis and compliance                 |
| Automated alerting        | Detect error patterns in logs and trigger SNS notifications or Lambda remediation     |

---

## TL;DR

> **Log Group:** Organizes and manages logs collectively.
> **Log Stream:** Sequential channel where applications write logs.
> Together, they provide centralized, persistent, and searchable logs for monitoring, analytics, and automation.

---

