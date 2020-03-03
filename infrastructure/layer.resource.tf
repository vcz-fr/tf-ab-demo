# [INFO] Create an archive from the crud Layer code
data "archive_file" "lyr-crud" {
  type = "zip"

  source_dir  = "../application/layers/crud"
  output_path = ".out/lyr-crud.zip"
}

# [INFO] Provision the crud Layer
resource "aws_lambda_layer_version" "lyr-crud" {
  filename         = data.archive_file.lyr-crud.output_path
  source_code_hash = data.archive_file.lyr-crud.output_base64sha256
  layer_name       = "crud"

  # This Layer would be compatible with older versions of the runtime as well
  # In this case: we keep it simple
  compatible_runtimes = ["nodejs12.x"]
}
