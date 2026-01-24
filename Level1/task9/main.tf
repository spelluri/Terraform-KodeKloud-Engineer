resource "aws_ebs_volume" "xfusion-volume" {
    availability_zone = "us-east-1a"
    size = 2
    type = "gp3"
    tags = {
        Name = "xfusion-volume"
    }

}