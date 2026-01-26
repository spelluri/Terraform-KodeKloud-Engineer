resource "aws_kinesis_stream" "devops_stream" {
    name = "devops-stream"

    stream_mode_details {
        stream_mode = "ON_DEMAND"
    }
}