resource "tls_private_key" "datacenter-keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "datacenter_kp" {
  key_name   = "datacenter-kp"
  public_key = tls_private_key.datacenter-keypair.public_key_openssh
}
resource "local_file" "private_key_file" {
  content  = tls_private_key.datacenter-keypair.private_key_pem
  filename = "/home/bob/datacenter-kp.pem"
  file_permission = "0600"
}
