resource "aws_key_pair" "xfusion-kp" {
    key_name   = "xfusion-kp"
    public_key = file("~/.ssh/xfusion-kp.pub")
}


resource "aws_instance" "xfusion-ec2" {
    ami = "ami-0c101f26f147fa7fd" # Amazon Linux 2 AMI (HVM), SSD Volume Type
    instance_type = "t2.micro"
    key_name = aws_key_pair.xfusion-kp.key_name

    tags = {
        Name = "xfusion-ec2"
    }
}