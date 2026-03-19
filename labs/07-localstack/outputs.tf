output "bucket_name" {
  description = "S3 bucket 名称"
  value       = aws_s3_bucket.app_bucket.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.app_bucket.arn
}

output "dynamodb_table" {
  description = "DynamoDB state lock 表名"
  value       = aws_dynamodb_table.state_lock.name
}

output "iam_role_arn" {
  description = "IAM Role ARN"
  value       = aws_iam_role.app_role.arn
}
