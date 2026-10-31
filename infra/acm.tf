resource "aws_acm_certificate" "app" {
  domain_name       = "app.nitzan-assignment.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.app.arn
}

output "acm_dns_validation" {
  value = [
    for record in aws_acm_certificate.app.domain_validation_options : {
      name  = record.resource_record_name
      type  = record.resource_record_type
      value = record.resource_record_value
    }
  ]
}