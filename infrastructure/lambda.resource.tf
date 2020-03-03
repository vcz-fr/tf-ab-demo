# [INFO] Create an archive from the decision Lambda function code
data "archive_file" "lbd-decision" {
  type        = "zip"
  source_dir  = "../application/lambdas/decision"
  output_path = ".out/lbd-decision.zip"
}

# [INFO] Provision the decision Lambda function
resource "aws_lambda_function" "lbd-decision" {
  filename         = data.archive_file.lbd-decision.output_path
  source_code_hash = data.archive_file.lbd-decision.output_base64sha256

  function_name = "decision"
  role          = aws_iam_role.role.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"

  # Adding the CRUD layer to this Lambda function
  # Make sure your runtime version is supported
  layers = [aws_lambda_layer_version.lyr-crud.arn]

  # Sensible timeout and max memory size
  timeout     = 10
  memory_size = 128

  environment {
    variables = {
      # Note that this environment variable is used in the layer but not in the function code!
      # This is possible because AWS creates the runtime environment from the function and all the layers
      # There is virtually no isolation between the function files and its dependencies other that the one provided
      # by the technology
      TABLE_NAME = aws_dynamodb_table.table.name
    }
  }
}

# ----------

# Same process for the statistics Lambda function
data "archive_file" "lbd-statistics" {
  type        = "zip"
  source_dir  = "../application/lambdas/statistics"
  output_path = ".out/lbd-statistics.zip"
}

resource "aws_lambda_function" "lbd-statistics" {
  filename         = data.archive_file.lbd-statistics.output_path
  source_code_hash = data.archive_file.lbd-statistics.output_base64sha256

  function_name = "statistics"
  role          = aws_iam_role.role.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"

  layers = [aws_lambda_layer_version.lyr-crud.arn]

  timeout     = 10
  memory_size = 128

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.table.name
    }
  }
}
