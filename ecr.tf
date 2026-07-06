resource "aws_ecr_repository" "app_repo" {
	name = "gitops-repo"
	image_tag_mutability= "MUTABLE"

	image_scanning_configuration {
		scan_on_push = true
	}
	
	tags = {
	 Environment = "dev"
	 Terraform = "true"
	}
}
	output "ecr_repository_url" {
		description = "URL of ECR repo"
		value = aws_ecr_repository.app_repo.repository_url	
	}
