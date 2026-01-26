resource "aws_ssm_parameter" "devops_ssm_parameter" {
    name = "devops-ssm-parameter"
    type = "String"
    value = "devops-value"
}