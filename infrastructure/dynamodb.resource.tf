# [INFO] This table contains two required attributes
# The other attributes are created dynamically by the code
resource "aws_dynamodb_table" "table" {
  name = "ddb-user_decision"

  billing_mode = "PAY_PER_REQUEST"

  # The decision ID is the primary attribute and part of the key
  # This attribute alone will be used when requesting content, hence the interest for partitioning on the DID instead
  # of the UID
  hash_key = "did"

  # The User ID is the secondary attribute and part of the key
  # This attribute is part of the key but its intervention is not relevant when requesting content, explaining why this
  # is the range key
  range_key = "uid"

  attribute {
    name = "did"
    type = "S" # String
  }

  attribute {
    name = "uid"
    type = "S" # String
  }
}
