locals {
  tags = merge(local.module_tags, var.tags)
  module_tags = {
    Terraform       = "true"
    Module          = "Codebuild"
    ModuleLocation  = "Github_URL"
    ProjectLocation = var.github_url
  }
  aws_ecr_poweruser_policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map
  default     = {}
}

variable "build_timeout" {
  description = "Set the default timeout for CodeBuild"
  type        = string
  default     = "5"
}

variable "build_compute_type" {
  description = "Compute type to use.\nMore info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "build_image" {
  description = "Docker image to use for Codebuild project\nMore info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html"
  type        = string
  default     = "aws/codebuild/standard:3.0"
}

variable "privileged_mode" {
  description = "Whether or not to run the container in privileged mode"
  type        = string
  default     = true
}

variable "environment_type" {
  description = "Type of environment CodeBuild should run in.\nMore info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html "
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "github_token_ssm_parameter" {
  description = "SSM parameter name that contains a Github token for pulling the source code"
  type        = string
  default     = "/github/token"
}

variable "environment_variables" {
  description = "List of maps with keys of name, value, type. If type is not specified, it will default to 'PLAINTEXT'.\nMore info: https://docs.aws.amazon.com/codebuild/latest/APIReference/API_EnvironmentVariable.html"
  type        = list
  default     = []
}

variable "webhook_filters" {
  description = "CodeBuild webhook filters.\nMore info: https://docs.aws.amazon.com/codebuild/latest/userguide/sample-github-pull-request.html#sample-github-pull-request-filter-webhook-events"
  type        = list
}

variable "project_name" {
  description = "Name to use across the resources this module creates"
  type        = string
}

variable "github_url" {
  description = "The project's Github url"
  type        = string
}

variable "codebuild_custom_policy" {
  description = "JSON formed IAM policy document"
  type        = string
  default     = ""
}
