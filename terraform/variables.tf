variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "devops-eks-cluster"
}

variable "key_pair_name" {
  default = "your-key-name"
}

variable "private_key_path" {
  default = "~/.ssh/your-key.pem"
}

