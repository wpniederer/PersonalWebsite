data "aws_s3_object" "personal_website_function_hash" {
  bucket = var.artifact_bucket
  key    = "PersonalWebsite/app-package-${var.tag}.zip.base64sha256"
}

resource "aws_lambda_function" "personal_website" {
  function_name                  = "PersonalWebsiteUI-${var.env}"
  role                           = aws_iam_role.lambda_exec.arn
  reserved_concurrent_executions = 1
  timeout                        = 10
  publish                        = "true"

  s3_bucket        = var.artifact_bucket
  s3_key           = "PersonalWebsite/app-package-${var.tag}.zip"
  source_code_hash = data.aws_s3_object.personal_website_function_hash.body

  runtime = "nodejs14.x"
  handler = "node_modules/nextjs12-serverless/lib/next/server.handler"

  lifecycle {
    ignore_changes = [
      source_code_hash,
      last_modified,
      qualified_arn,
      version
    ]
  }
}

resource "aws_cloudwatch_log_group" "personal_website" {
  name = "/aws/lambda/${aws_lambda_function.personal_website.function_name}"

  retention_in_days = 5
}

resource "aws_iam_role" "lambda_exec" {
  name = "personal_website_serverless_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
