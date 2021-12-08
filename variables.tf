variable "alb_name" {
  type = string
}

variable "waf_stream_name" {
  type = string
  default = "aws-waf-logs-notsosecure-webserver"
}
