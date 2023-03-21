data "archive_file" "lambda_gateway_src" {
  type        = "zip"
  source_dir  = "../package/lambda_gateway/dist"
  output_path = "lambda_gateway.zip"
}

resource "aws_lambda_function" "gateway" {
  filename      = data.archive_file.lambda_gateway_src.output_path
  function_name = "chat-gpt-slack-bot-gateway"
  role          = aws_iam_role.lambda_gateway.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda_gateway_src.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      SSM_KEY_CHAT_GPT_API_KEY = data.aws_ssm_parameter.chat_gpt_api_key.name
    }
  }

  timeout = 30
  publish = true
}