# Generate the archive
data "archive_file" "lyr-crud" {
  type = "zip"

  source_dir  = "../../application/layers/crud"
  output_path = ".out/lyr-crud.zip"
}

resource "aws_lambda_layer_version" "lyr-crud" {
  filename            = data.archive_file.lyr-crud.output_path
  source_code_hash    = data.archive_file.lyr-crud.output_base64sha256
  layer_name          = "crud"
  compatible_runtimes = ["nodejs12.x"]
}
