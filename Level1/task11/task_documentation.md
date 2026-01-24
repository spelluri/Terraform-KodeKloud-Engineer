# Terraform CloudWatch Alarm Task Documentation

This document explains **Amazon CloudWatch**, CloudWatch alarms, and documents the task of creating a CPU utilization alarm for an EC2 instance using Terraform.

---

## What is Amazon CloudWatch?

**Amazon CloudWatch** is AWS’s native **monitoring and observability service**. It collects, tracks, and visualizes metrics, logs, and events from AWS resources and applications.

### CloudWatch can:

* Monitor resource health (EC2, EBS, RDS, Lambda, etc.)
* Collect metrics like CPU, memory, disk, and network
* Store and analyze logs
* Trigger alarms and automated actions

CloudWatch is a **core service for DevOps monitoring and reliability**.

---

## What is a CloudWatch Alarm?

A **CloudWatch alarm** watches a specific metric and performs an action when a condition is met.

Examples:

* CPU usage > 80%
* Disk space < 10%
* Network traffic spikes

Alarms are commonly used to:

* Alert teams (via SNS, email, Slack)
* Trigger auto scaling
* Detect performance or availability issues early

---

## Task Overview

As part of the Nautilus DevOps team’s monitoring setup, the task is to **create a CloudWatch alarm using Terraform**.

### Task Requirements

* **Alarm Name:** `nautilus-alarm`
* **Metric:** EC2 CPU Utilization
* **Threshold:** Trigger when CPU > 80%
* **Evaluation Period:** 5 minutes (300 seconds)
* **Evaluation Period Count:** 1
* **Terraform Directory:** `/home/bob/terraform`
* **File:** `main.tf` (do not create additional `.tf` files)

---

## Important Concept: EC2 Instance Dependency

CloudWatch alarms **do not create resources**.
They **monitor existing resources**.

For EC2 CPU monitoring, CloudWatch **requires an EC2 Instance ID** using metric dimensions.

If EC2 details are not explicitly provided, Terraform must **discover the instance dynamically**.

---

## Terraform Implementation

### Step 1: Fetch the existing EC2 instance

Since EC2 details are not provided, use a **Terraform data source** to find the instance by its Name tag:

```hcl
data "aws_instance" "target_ec2" {
  filter {
    name   = "tag:Name"
    values = ["devops-ec2"]
  }
}
```

This allows Terraform to reference an existing EC2 instance without creating one.

---

### Step 2: Create the CloudWatch Alarm

```hcl
resource "aws_cloudwatch_metric_alarm" "nautilus_alarm" {
  alarm_name          = "nautilus-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = data.aws_instance.target_ec2.id
  }

  alarm_description = "Alarm triggers when CPU utilization exceeds 80%"
}
```

---

## Terraform Apply

```bash
cd /home/bob/terraform
terraform init
terraform apply -auto-approve
```

Terraform will create the alarm and immediately begin monitoring the EC2 instance.

---

## Why Dimensions Are Required

CloudWatch metrics use **dimensions** to uniquely identify a resource.

For EC2 CPU metrics:

* Namespace: `AWS/EC2`
* Metric: `CPUUtilization`
* Dimension: `InstanceId`

Without dimensions, CloudWatch cannot determine **which EC2 instance to monitor**.

---

## Purpose of This Task

* Establish monitoring as part of incremental AWS migration
* Detect high CPU usage early
* Demonstrate infrastructure observability using Terraform
* Enforce monitoring through Infrastructure as Code (IaC)

---

## TL;DR

> This task creates a **CloudWatch alarm named `nautilus-alarm`** that monitors **EC2 CPU usage** and triggers when it exceeds **80% for 5 minutes**, using Terraform and dynamic EC2 discovery.

---

