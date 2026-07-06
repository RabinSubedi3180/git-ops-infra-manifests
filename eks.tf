module "eks" {
	source = "terraform-aws-modules/eks/aws"
	version = "~> 20.0"

	cluster_name = "gitops-cluster"
	cluster_version = "1.31"

	cluster_endpoint_public_access = true

	vpc_id 	   = module.vpc.vpc_id
	subnet_ids = module.vpc.private_subnets

	# Automatically maps current AWS CLI profile as Cluster Admin
	enable_cluster_creator_admin_permissions = true
	
	eks_managed_node_groups = {
		worker_nodes = {
			min_size 	= 1
			max_size 	= 3
			desired_size	= 2
			instance_types  = ["t3.medium"]
		}
	} 
	
	tags = {
	Environment = "dev"
	Terraform = "true"	
		}
}