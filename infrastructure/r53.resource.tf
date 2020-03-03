# [INFO] This data requires a private zone to exist within the account
# The zone name must match your current internal zone name
# Make sure the zone name is attached to the same VPC you are deploying your application into
data "aws_route53_zone" "selected" {
  name         = "vcz.internal."
  private_zone = true
}

# [INFO] Provision the alias DNS record pointing to the ALB
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
