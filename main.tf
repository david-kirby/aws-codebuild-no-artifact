########################
# Codebuild Resources
########################
resource "aws_codebuild_project" "main" {
  name          = var.project_name
  description   = "Codebuild project for ${var.project_name}"
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.codebuild.arn
  tags          = local.tags

  environment {
    compute_type    = var.build_compute_type
    image           = var.build_image
    type            = var.environment_type
    privileged_mode = var.privileged_mode

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = lookup(environment_variable.value, "name")
        value = lookup(environment_variable.value, "value")
        type  = lookup(merge({ type = "PLAINTEXT" }, environment_variable.value), "type")
      }
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type                = "GITHUB"
    report_build_status = "true"
    location            = var.github_url
    auth {
      type     = "OAUTH"
      resource = aws_codebuild_source_credential.main.arn
    }
  }
}

resource "aws_codebuild_source_credential" "main" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = data.aws_ssm_parameter.github_token.value
}

resource "aws_codebuild_webhook" "main" {
  depends_on   = [aws_codebuild_project.main]
  project_name = aws_codebuild_project.main.name

  dynamic "filter_group" {
    for_each = var.webhook_filters
    content {
      dynamic "filter" {
        for_each = filter_group.value
        content {
          type                    = lookup(merge({ type = null }, filter.value), "type")
          pattern                 = lookup(merge({ pattern = null }, filter.value), "pattern")
          exclude_matched_pattern = lookup(merge({ exclude_matched_pattern = null }, filter.value), "exclude_matched_pattern")
        }
      }
    }
  }
}




####################
# IAM Configuration
####################
resource "aws_iam_role" "codebuild" {
  name               = "${var.project_name}-codebuild"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
  tags               = local.tags
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "${var.project_name}-default"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild_permissions.json
}

resource "aws_iam_role_policy" "custom_codebuild_policy" {
  count  = var.codebuild_custom_policy == null ? 0 : 1
  name   = "${var.project_name}-custom"
  role   = aws_iam_role.codebuild.id
  policy = var.codebuild_custom_policy
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.codebuild.name
  policy_arn = local.aws_ecr_poweruser_policy_arn
}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "ssm:DescribeParameters"
    ]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

###############
# Data Lookups
###############
data "aws_ssm_parameter" "github_token" {
  name = var.github_token_ssm_parameter
}
