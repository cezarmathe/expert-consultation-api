# expert-consultation-api - outputs

output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "api_ecr_repo" {
  value = aws_ecr_repository.api.repository_url
}

output "client_ecr_repo" {
  value = aws_ecr_repository.client.repository_url
}
