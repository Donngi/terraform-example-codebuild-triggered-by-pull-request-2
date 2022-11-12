import os
from logging import getLogger

import boto3

logger = getLogger(__name__)


def handle_request(event, context) -> None:
    logger.debug(f"event: {event}")

    repository_name = event["detail"]["repositoryNames"][0]
    source_commit = event["detail"]["sourceCommit"]
    codebuild_project_name = os.getenv("CODEBUILD_PROJECT_NAME")
    pull_request_id = event["detail"]["pullRequestId"]
    region = os.getenv("AWS_REGION")

    client = boto3.client("codebuild")
    res_run = client.start_build(
        projectName=codebuild_project_name,
        sourceLocationOverride=f"https://git-codecommit.{region}.amazonaws.com/v1/repos/{repository_name}",
        sourceVersion=source_commit,
        environmentVariablesOverride=[{
            "name": "PULL_REQUEST_ID",
            "value": pull_request_id,
            "type": "PLAINTEXT" 
        },
        {
            "name": "REPOSITORY_NAME",
            "value": repository_name,
            "type": "PLAINTEXT" 
        }],
    )

    logger.debug(f"event: {res_run}")
