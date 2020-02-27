data "aws_route53_zone" "selected" {
  name         = "vcz.internal."
  private_zone = true
}

resource "aws_route53_record" "ab" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "ab.${data.aws_route53_zone.selected.name}"
  type    = "A"
  
  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}
