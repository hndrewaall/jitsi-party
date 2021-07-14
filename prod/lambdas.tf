resource "aws_iam_role" "authbot_lambda" {
  name = "authbot_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "authbot" {
  function_name = "authbot"
  role          = aws_iam_role.authbot_lambda.arn
  image_uri = "cabinweekend/authbot:0.1.0"


  environment {
    variables = {
      foo = "bar"
    }
  }
}
