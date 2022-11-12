resource "aws_iam_role" "codebuild" {
  name = "ci-pull-request-codebuild-role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "codebuild.amazonaws.com"
          },
          "Effect" : "Allow",
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "codebuild" {
  role = aws_iam_role.codebuild.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowCodeCommitAccess",
          "Effect" : "Allow",
          "Action" : [
            "codecommit:GitPull",
            "codecommit:GetPullRequest",
            "codecommit:PostCommentForPullRequest",
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "AllowCloudWatchAccess"
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          "Resource" : "*",
        },
      ]
  })
}
