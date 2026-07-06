\# AWS EKS Core Infrastructure \& GitOps Manifests



This repository contains the declarative Infrastructure as Code (IaC) and GitOps manifests used to provision and manage a secure, production-grade cloud environment on Amazon Web Services (AWS). 
This repo serves as the **Foundation Layer** of a decoupled, 3-tier GitOps ecosystem.

The infrastructure is provisioned using \*\*Terraform\*\* and continuously reconciled using a pull-based \*\*GitOps architecture via ArgoCD\*\* inside an Amazon EKS cluster.

\## Ecosystem Architecture

To mirror enterprise-grade security and operational boundaries, the entire application lifecyle is split across three independent repositories:

1.  **Core Infrastructure (This Repo):** Provisions the network fabric, container registries, and compute clusters via Terraform.
2.  **Application Workload:** Contains the Python Flask microservices source code and containerization configs (`Dockerfile`).
3.  **GitOps Orchestration:** Holds the Kubernetes `Deployment`, `Service`, and `Ingress` manifests continually reconciled by ArgoCD.

\---



\## Architecture Overview

The system isolates application source code from deployment configurations to enforce a zero-trust security boundary. 

\*   \*\*VPC \& Networking:\*\* Custom AWS VPC spanning multiple Availability Zones with public and private subnets, managed NAT Gateways, and isolated routing tables.

\*   \*\*Compute (Amazon EKS):\*\* A managed Kubernetes cluster executing containerized workloads inside secure, private worker nodes.

\*   \*\*Container Registry:\*\* Amazon ECR handles private container image storage with strict tag mutability policies.

\*   \*\*Continuous Deployment (GitOps):\*\* ArgoCD runs inside the EKS cluster, pulling state configurations from this repository and eliminating the need to expose cluster access keys to external CI pipelines.


\## Repository Structure


```text

├── .terraform.lock.hcl      # Provider lock file ensuring deterministic initialization

├── providers.tf            # AWS and Kubernetes provider configurations

├── vpc.tf                  # Networking, Subnets, Internet and NAT Gateways

├── eks.tf                  # Managed EKS Cluster and Worker Node Group definitions

├── ecr.tf                  # Private Amazon Elastic Container Registry setup

├── argo-app.yaml           # Root ArgoCD application manifest mapping target tracking

└── applicationset-crd.yaml # Custom Resource Definition for cluster automation patterns



Tech Stack & Tools
    Infrastructure as Code: Terraform >= 1.0
    Cloud Provider: Amazon Web Services (AWS)
    Container Orchestration: Amazon EKS \& Kubernetes
    Continuous Delivery: ArgoCD (GitOps Controller)
    Version Control Locking: HCL Provider Dependency Locks



Deployment & Initialization Guide

1. Prerequisites
    Ensure you have the AWS CLI configured with appropriate IAM administrative permissions, alongside Terraform installed locally.

            aws configure

            terraform --version



2. Provision AWS Infrastructure
    Initialize the working directory to download the required AWS/Kubernetes provider binaries, inspect the execution plan, and apply changes to provision the VPC, ECR, and EKS cluster.

        #Initialize and lock provider versions
            terraform init

        # Generate and review speculative execution plan
            terraform plan -out=tfplan

        # Apply the infrastructure configuration
            terraform apply tfplan

3. Connect to the EKS Cluster
    Once Terraform finishes provisioning, update your local kubeconfig to safely communicate with your new EKS cluster cluster.

        aws eks update-kubeconfig --region <your-aws-region> --name <your-cluster-name>



4. GitOps Reconcile Loop
    Apply the root argo-app.yaml manifest. ArgoCD will instantly ingest the configuration, hook into your repository tracking, and spin up your application workloads into the target namespaces.

        kubectl apply -f argo-app.yaml


Security Posture & Practices
    Zero-Trust CI/CD: External automated CI pipelines (like GitHub Actions) are only permitted to push built images to Amazon ECR. They maintain zero access keys to the live Kubernetes cluster.

    State Locking: .terraform.lock.hcl is committed to prevent configuration drift or supply chain attacks via unverified provider updates.

    Secret Minimization: No state parameters or plain-text secrets are stored within this public configuration tracking layer.

