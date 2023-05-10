resource "aws_ecr_repository" "dvwa" {
  name                 = "dvwa"

  image_scanning_configuration {
    scan_on_push = true
  }
}