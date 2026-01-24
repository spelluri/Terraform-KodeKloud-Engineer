resource "aws_ami_from_instance" "devops-ec2" {
    name = "devops-ec2-ami"
    source_instance_id = aws_instance.ec2.id
    snapshot_without_reboot = true
    tags = {
        Name = "devops-ec2-ami"
    }
}
