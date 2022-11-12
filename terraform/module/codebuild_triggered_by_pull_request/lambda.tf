data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/upload/lambda.zip"
}

resource "aws_lambda_function" "pull_request" {
  filename      = data.archive_file.lambda.output_path
  function_name = "ci-pull-request-runner"
  role          = aws_iam_role.lambda_pull_request.arn
  handler       = "handler.handle_request"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"

  environment {
    variables = {
      CODEBUILD_PROJECT_NAME = aws_codebuild_project.pull_request.name
    }
  }

  timeout = 60
  publish = true
}

resource "aws_lambda_permission" "pull_request" {
  statement_id  = "AllowEventBridgeToInvokeFunction"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pull_request.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.pull_request.arn
}
