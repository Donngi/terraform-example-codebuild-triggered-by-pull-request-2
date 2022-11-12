resource "aws_codebuild_project" "pull_request" {
  name          = "ci-pull-request"
  description   = "Triggered by pull request."
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type     = "CODECOMMIT"
    location = aws_codecommit_repository.dummy.clone_url_http

    buildspec = file("${path.module}/buildspec.yml")
  }

  source_version = "main"
}
