resource "aws_ssm_parameter" "image_tag" {

  name      = local.image_tags_name
  type      = "String"
  value     = local.image_tags_value
  data_type = local.image_tags_data_type

  tags = {
    environment = local.environment
    Terraform   = true
  }
}