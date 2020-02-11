output "codebuild_project" {
  description = "All attributes for the CodeBuild project"
  value       = aws_codebuild_project.main.*
}

output "codebuild_role" {
  description = "All attributes for the CodeBuild IAM role"
  value       = aws_iam_role.codebuild.*
}

