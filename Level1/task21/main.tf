resource "aws_cloudwatch_log_group" "nautilus_log_group" {
    name = "nautilus-log-group"
}

resource "aws_cloudwatch_log_stream" "nautilus_log_stream" {
    name = "nautilus-log-stream"
    log_group_name = aws_cloudwatch_log_group.nautilus_log_group.name
}