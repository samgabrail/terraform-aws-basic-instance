locals {
  bucket_name = "${var.prefix}-${random_pet.this.id}"
}

resource "random_pet" "this" {
  length = 2
}

module "s3-bucket" {
  source     = "app.terraform.io/larryebaum-demo/s3-bucket/aws"
  version    = "1.6.0"
  bucket     = local.bucket_name
  acl        = "private"
  versioning = {
    enabled = true
  }
  
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.objects.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
