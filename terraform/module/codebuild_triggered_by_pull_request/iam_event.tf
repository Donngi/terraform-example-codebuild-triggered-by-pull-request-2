resource "aws_iam_role" "event_pull_request" {
  name = "ci-pull-request-event-role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "events.amazonaws.com"
          },
          "Effect" : "Allow",
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "event_pull_request" {
  role = aws_iam_role.event_pull_request.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "codebuild:StartBuild"
        ],
        "Resource" : [
          aws_codebuild_project.pull_request.arn
        ]
      }
    ]
  })
}
