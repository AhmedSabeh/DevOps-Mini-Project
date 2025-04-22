Deploy a containerized web application on AWS EKS using Docker, Git, Terraform, and Ansible
# 🚀 DevOps Mini Project — Full Stack Deployment on AWS with Docker, Kubernetes, Terraform, and Ansible

This is a hands-on mini project that brings together the essential tools in the DevOps toolkit. The goal is to deploy a simple web application to an EKS cluster using Docker, Kubernetes, Terraform, Ansible, and AWS services.

---

## 🧰 Tech Stack

- **Linux**: Admin EC2 instance
- **Git**: Version control
- **Docker**: Containerize the application
- **Terraform**: Infrastructure as Code (IaC)
- **Ansible**: Server provisioning
- **AWS**: Cloud platform
  - EC2, VPC, EKS, ECR, IAM
- **Kubernetes**: Container orchestration (EKS)

---

## 🔧 Project Flow

### ✅ Step 1: Setup Project Structure

devops-mini-project/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/
│   ├── inventory.ini
│   └── playbook.yml
├── app/
│   ├── Dockerfile
│   └── index.html
├── kubernetes/
│   ├── deployment.yaml
│   └── service.yaml
└── README.md


---

### ✅ Step 2: Infrastructure Setup with Terraform

1. **VPC, Subnets, Internet Gateway, Route Tables**
2. **EKS Cluster and Node Group**
3. **IAM roles and security groups**
4. **EC2 Instance for Ansible (Admin box)**
5. **ECR Repository**

Run:

```bash
cd terraform
terraform init
terraform apply
```
---
### ✅ Step 3: Configure EC2 Admin Box with Ansible
SSH into the EC2 instance and use Ansible to:

Install Docker

Install AWS CLI, kubectl, and eksctl

Prepare for image builds and Kubernetes commands
```
cd ansible
ansible-playbook -i inventory.ini playbook.yml
```
### ✅ Step 4: Build Docker Image and Push to ECR
On the EC2 admin box:

```bash
Copy
Edit
cd ~/demo-app
docker build -t devops-demo-app .
```
# Authenticate to ECR
```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <your-ecr-url>
```
# Tag and push
```
docker tag devops-demo-app:latest <your-ecr-url>:v1
docker push <your-ecr-url>:v1
```
---

✅ Step 5: Deploy App to EKS using kubectl
On the EC2 admin box:
```
# Configure kubeconfig
aws eks --region us-east-1 update-kubeconfig --name devops-eks-cluster
```
# Deploy app
```
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
```
# Get LoadBalancer IP
```
kubectl get svc demo-service
```
🌐 Access the App
Open the EXTERNAL-IP of the demo-service in your browser.
