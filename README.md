## Terraform
Version |
|---------|
| ~> 0.12.20 |
## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.44.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| codebuild_custom_policy | JSON formed IAM policy document | `string` | n/a | yes |
| github_url | The project's Github url | `string` | n/a | yes |
| project_name | Name to use across the resources this module creates | `string` | n/a | yes |
| webhook_filters | CodeBuild webhook filters.<br>More info: https://docs.aws.amazon.com/codebuild/latest/userguide/sample-github-pull-request.html#sample-github-pull-request-filter-webhook-events | `list` | n/a | yes |
| build_compute_type | Compute type to use.<br>More info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| build_image | Docker image to use for Codebuild project<br>More info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html | `string` | `"aws/codebuild/standard:3.0"` | no |
| build_timeout | Set the default timeout for CodeBuild | `string` | `"5"` | no |
| environment_type | Type of environment CodeBuild should run in.<br>More info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html | `string` | `"LINUX_CONTAINER"` | no |
| environment_variables | List of maps with keys of name, value, type. If type is not specified, it will default to 'PLAINTEXT'.<br>More info: https://docs.aws.amazon.com/codebuild/latest/APIReference/API_EnvironmentVariable.html | `list` | `[]` | no |
| github_token_ssm_parameter | SSM parameter name that contains a Github token for pulling the source code | `string` | `"/github/token"` | no |
| privileged_mode | Whether or not to run the container in privileged mode | `string` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| codebuild_project | All attributes for the CodeBuild project |
| codebuild_role | All attributes for the CodeBuild IAM role |