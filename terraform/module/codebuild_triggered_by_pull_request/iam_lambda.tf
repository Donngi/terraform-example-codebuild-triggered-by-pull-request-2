resource "aws_iam_role" "lambda_pull_request" {
  name = "lambda-ci-pull-request-role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
        }
      ]
    }
  )
}

resource "aws_iam_policy" "lambda_pull_request" {
  name = "${aws_iam_role.lambda_pull_request.name}-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "AllowAccessToCodeBuild",
        "Effect" : "Allow",
        "Action" : [
          "codebuild:StartBuild",
        ],
        "Resource" : aws_codebuild_project.pull_request.arn,
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_pull_request" {
  role       = aws_iam_role.lambda_pull_request.name
  policy_arn = aws_iam_policy.lambda_pull_request.arn
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_pull_request.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
