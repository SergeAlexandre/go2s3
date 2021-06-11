

resource "aws_s3_bucket" "gha1p1" {
  bucket = "gha1-primary-1"
  acl    = "private"

  tags = {
    owner = "sergea"
  }
}

resource "aws_s3_bucket" "gha1s1" {
  bucket = "gha1-secondary-1"
  acl    = "private"

  tags = {
    owner = "sergea"
  }
}


resource "aws_s3_bucket" "gha1spark" {
  bucket = "gha1-spark"
  acl    = "private"

  tags = {
    owner = "sergea"
  }
}


resource "aws_s3_bucket" "gha2p1" {
  bucket = "gha2-primary-1"
  acl    = "private"

  tags = {
    owner = "sergea"
  }
}


resource "aws_s3_bucket" "ghac1" {
  bucket = "gha-common-1"
  acl    = "private"

  tags = {
    owner = "sergea"
  }
}


resource "aws_s3_bucket_object" "o1" {
  bucket = aws_s3_bucket.gha1p1.id
  key    = "gha1_primary1_content/xx.txt"
  source = "./provider.tf"
}


resource "aws_s3_bucket_object" "o2" {
  bucket = aws_s3_bucket.gha2p1.id
  key    = "gha1_primary2_content/xx.txt"
  source = "./provider.tf"
}

resource "aws_s3_bucket_object" "o0" {
  bucket = aws_s3_bucket.ghac1.id
  key    = "gha_common_content/xx.txt"
  source = "./provider.tf"
}


