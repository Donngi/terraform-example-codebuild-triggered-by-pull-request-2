resource "aws_cloudwatch_event_rule" "pull_request" {
  name        = "ci-pull-request"
  description = "Trigger CodeBuild project when pull request is created or source branch updated."

  event_pattern = jsonencode({
    "detail-type" : [
      "CodeCommit Pull Request State Change"
    ],
    "detail" : {
      "event" : [
        "pullRequestCreated",
        "pullRequestSourceBranchUpdated",
      ],
      "pullRequestStatus" : [
        "Open",
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "pull_request" {
  rule = aws_cloudwatch_event_rule.pull_request.id
  arn  = aws_lambda_function.pull_request.arn
}


# NOTE: If CodeBuild supports dynamic path parameters, we can simply achieve what we want to do with the following configuration.
# https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-targets.html

# resource "aws_cloudwatch_event_target" "pull_request" {
#   rule = aws_cloudwatch_event_rule.pull_request.id
#   arn  = aws_codebuild_project.pull_request.arn

#   role_arn = aws_iam_role.event_pull_request.arn

#   input = jsonencode({
#     "sourceLocationOverride" : "$.detail.repositoryNames[0]",
#     "sourceVersion" : "$.detail.sourceCommit",
#   })
# }
