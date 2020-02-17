resource "aws_dynamodb_table" "table" {
  name = "ddb-user_decision"

  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "did"
  range_key    = "uid"

  attribute {
    name = "did"
    type = "S"
  }

  attribute {
    name = "uid"
    type = "S"
  }

  tags = {
    Project      = 1345
    Automated    = true
    BU           = "RD"
    BillingCycle = "FULL"
  }
}
