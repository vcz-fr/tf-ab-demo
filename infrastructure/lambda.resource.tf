data "archive_file" "lbd-decision" {
  type        = "zip"
  source_dir  = "../application/lambdas/decision"
  output_path = ".out/lbd-decision.zip"
}

resource "aws_lambda_function" "lbd-decision" {
  filename         = data.archive_file.lbd-decision.output_path
  source_code_hash = data.archive_file.lbd-decision.output_base64sha256

  function_name = "decision"
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

  tags = local.tags
}

# ----------

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

  tags = local.tags
}
