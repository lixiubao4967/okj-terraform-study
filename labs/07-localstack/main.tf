locals {
  name_prefix = "${var.project}-${var.environment}"
}

# ============================================================
# 1. S3 Bucket：存储应用文件
# ============================================================

resource "aws_s3_bucket" "app_bucket" {
  bucket = "${local.name_prefix}-bucket"
}

resource "aws_s3_bucket_versioning" "app_bucket" {
  bucket = aws_s3_bucket.app_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 上传一个示例文件
resource "aws_s3_object" "config" {
  bucket  = aws_s3_bucket.app_bucket.id
  key     = "config/app.json"
  content = jsonencode({
    environment = var.environment
    project     = var.project
    created_by  = "terraform"
  })
  content_type = "application/json"
}

# ============================================================
# 2. DynamoDB：Terraform state lock 表（生产必备）
# ============================================================

resource "aws_dynamodb_table" "state_lock" {
  name         = "${local.name_prefix}-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# ============================================================
# 3. IAM Role：应用服务角色
# ============================================================

resource "aws_iam_role" "app_role" {
  name = "${local.name_prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "app_s3_policy" {
  name = "${local.name_prefix}-s3-policy"
  role = aws_iam_role.app_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
      Resource = [
        aws_s3_bucket.app_bucket.arn,
        "${aws_s3_bucket.app_bucket.arn}/*"
      ]
    }]
  })
}
