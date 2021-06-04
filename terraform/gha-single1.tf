provider "aws" {
  region  = "us-east-2"
  profile = "bssa"
}

data "aws_caller_identity" "account" {}


resource "aws_iam_instance_profile" "single1_instance" {
  name = "single1_instance"
  role = aws_iam_role.single1_instance.name
}

# This role to be attached to all instances of single1 (Only one for now).
resource "aws_iam_role" "single1_instance" {
  name = "single1_instance"
  managed_policy_arns = [aws_iam_policy.single1_access_s3_gha.arn]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "Allow_switch_to_gha1_gha2"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["sts:AssumeRole"]
          Effect   = "Allow"
          Resource = [
            format("arn:aws:iam::%s:role/single1_gha1", data.aws_caller_identity.account.account_id),
            format("arn:aws:iam::%s:role/single1_gha2", data.aws_caller_identity.account.account_id),
          ]
        },
      ]
    })
  }

//  inline_policy {
//    name = "Allow_switch_to_gha2"
//    policy = jsonencode({
//      Version = "2012-10-17"
//      Statement = [
//        {
//          Action   = ["sts:AssumeRole"]
//          Effect   = "Allow"
//          Resource = format("arn:aws:iam::%s:role/single1_gha2", data.aws_caller_identity.account.account_id)
//        },
//      ]
//    })
//  }

  tags = {
    owner = "sergea"
  }
}

resource "aws_iam_role" "single1_gha1" {
  name = "single1_gha1"
  managed_policy_arns = [aws_iam_policy.single1_access_s3_gha1.arn]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = format("arn:aws:iam::%s:root", data.aws_caller_identity.account.account_id)
        }
      },
    ]
  })

  tags = {
    owner = "sergea"
  }
}


resource "aws_iam_role" "single1_gha2" {
  name = "single1_gha2"
  managed_policy_arns = [aws_iam_policy.single1_access_s3_gha2.arn]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = format("arn:aws:iam::%s:root", data.aws_caller_identity.account.account_id)
        }
      },
    ]
  })

  tags = {
    owner = "sergea"
  }
}



# ---- Policies

resource "aws_iam_policy" "single1_access_s3_gha1" {
  name = "single1_access_s3_gha1"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::gha1-*"
      },
    ]
  })
}


resource "aws_iam_policy" "single1_access_s3_gha2" {
  name = "single1_access_s3_gha2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::gha2-*"
      },
    ]
  })
}


resource "aws_iam_policy" "single1_access_s3_gha" {
  name = "single1_access_s3_gha"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::gha-*"
      },
    ]
  })
}


output "account_id" {
  value = data.aws_caller_identity.account.account_id
}
