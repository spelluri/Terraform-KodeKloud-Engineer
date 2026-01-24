resource "aws_ebs_snapshot" "devops-vol-ss" {
    volume_id = aws_ebs_volume.k8s_volume.id
    description = "Devops Snapshot"
    tags = {
        Name = "devops-vol-ss"
    }
}