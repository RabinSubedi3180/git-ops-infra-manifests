module "vpc" {
	source = "terraform-aws-modules/vpc/aws"
	version = "~> 5.0"

	name = "gitops-vpc"
	cidr = "10.0.0.0/16"

	#Spread across 3 availability zones for high availability
	azs		= ["eu-north-1a","eu-north-1b","eu-north-1c"]
	private_subnets = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
	public_subnets  = ["10.0.101.0/24","10.0.102.0/24","10.0.103.0/24"]
	
	#Enable NAT Gateway so private nodes can pull images from ECR/Dockerhub
	enable_nat_gateway = true
	single_nat_gateway = true
	
	public_subnet_tags = {
		"kubernetes.io/role/elb" = "1"
	}
	
	private_subnet_tags = {
		"kubernetes.io/role/internal-elb" = "1"
	}

	tags = {
		Environment = "dev"
		Terraform = "true"
	}

}