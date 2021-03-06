resource "aws_lambda_function" "export_for_llm" {
  function_name = "theyhelpyou_export_for_llm"
  runtime       = "python3.7"
  handler       = "export_for_llm.lambda_handler"
  filename      = "empty.zip"
  role          = aws_iam_role.theyhelpyou-lambdas.arn
  publish       = true
  timeout       = 30

  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
}

resource "aws_cloudwatch_log_group" "export_for_llm" {
  name              = "/aws/lambda/${aws_lambda_function.export_for_llm.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "fetch_by_postcode" {
  function_name = "theyhelpyou_fetch_by_postcode"
  runtime       = "python3.7"
  handler       = "fetch_by_postcode.lambda_handler"
  filename      = "empty.zip"
  role          = aws_iam_role.theyhelpyou-lambdas.arn
  publish       = true
  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }

}
resource "aws_cloudwatch_log_group" "fetch_by_postcode" {
  name              = "/aws/lambda/${aws_lambda_function.fetch_by_postcode.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "import_sheet" {
  function_name = "theyhelpyou_import_sheet"
  runtime       = "python3.7"
  handler       = "import_sheet.lambda_handler"
  filename      = "empty.zip"
  role          = aws_iam_role.theyhelpyou-lambdas.arn
  publish       = true
  timeout       = 30

  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
}

resource "aws_cloudwatch_log_group" "import_sheet" {
  name              = "/aws/lambda/${aws_lambda_function.import_sheet.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "report_a_problem" {
  function_name = "theyhelpyou_report_a_problem"
  runtime       = "python3.7"
  handler       = "report_a_problem.lambda_handler"
  filename      = "empty.zip"
  role          = aws_iam_role.theyhelpyou-lambdas.arn
  publish       = true
  timeout       = 10

  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }

  environment {
    variables = {
      "WEBHOOK_URL" = data.aws_ssm_parameter.report_a_problem-WEBHOOK_URL.value
    }
  }
}

resource "aws_cloudwatch_log_group" "report_a_problem" {
  name              = "/aws/lambda/${aws_lambda_function.report_a_problem.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "update_attr" {
  function_name = "theyhelpyou_update_attr"
  runtime       = "python3.7"
  handler       = "update_attr.lambda_handler"
  filename      = "empty.zip"
  role          = aws_iam_role.theyhelpyou-lambdas.arn
  publish       = true


  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
  environment {
    variables = {
      "WEBHOOK_URL" = data.aws_ssm_parameter.update_attr-WEBHOOK_URL.value
    }
  }
}

resource "aws_cloudwatch_log_group" "update_attr" {
  name              = "/aws/lambda/${aws_lambda_function.update_attr.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "import_from_llm" {
  function_name = "theyhelpyou_import_from_llm"
  runtime       = "python3.7"
  handler       = "import_from_llm.lambda_handler"
  filename      = "empty.zip"
  role          = aws_iam_role.theyhelpyou-lambdas.arn
  publish       = true

  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
}

resource "aws_cloudwatch_log_group" "import_from_llm" {
  name              = "/aws/lambda/${aws_lambda_function.import_from_llm.function_name}"
  retention_in_days = 14
}

data "aws_ssm_parameter" "report_a_problem-WEBHOOK_URL" {
  name = "report_a_problem-WEBHOOK_URL"
}

data "aws_ssm_parameter" "update_attr-WEBHOOK_URL" {
  name = "update_attr-WEBHOOK_URL"
}
