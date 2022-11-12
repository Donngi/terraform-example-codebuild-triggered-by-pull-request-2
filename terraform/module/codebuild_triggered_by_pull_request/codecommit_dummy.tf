resource "aws_codecommit_repository" "dummy" {
  repository_name = "ci-pull-request-dummy"
  description     = "Dummy repository for ci-pull-request to initialize CodeBuild project."
}

resource "aws_codecommit_repository" "dummy_2" {
  repository_name = "ci-pull-request-dummy-2"
  description     = "Dummy repository for ci-pull-request to initialize CodeBuild project."
}