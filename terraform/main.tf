provider "aws" {
  region = var.aws_region
}

# Create ECR repo for Docker image
resource "aws_ecr_repository" "app_repo" {
  name = "flask-devops-app"  # You can use your desired name here (e.g., flask-devops-app or devops-demo-app)
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "devops-demo-app"
  }
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

# VPC setup using terraform-aws-modules
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "devops-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Name = "devops-vpc"
  }
}

# EKS setup using terraform-aws-modules
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true

  eks_managed_node_groups = {
    dev_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }

  tags = {
    Environment = "dev"
    Project     = "devops-mini-project"
  }
}

# Admin EC2 instance for Ansible setup
resource "aws_instance" "admin" {
  ami           = "ami-0c7217cdde317cfec"  # Amazon Linux 2 AMI for us-east-1
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = var.key_pair_name

  associate_public_ip_address = true

  tags = {
    Name = "admin-instance"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Bootstrapped'"]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}

output "admin_public_ip" {
  value = aws_instance.admin.public_ip
}
