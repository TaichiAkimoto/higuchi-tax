#!/bin/bash
set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Mendoi Backend Deployment Script${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    echo -e "${RED}Error: terraform.tfvars not found!${NC}"
    echo -e "${YELLOW}Please copy terraform.tfvars.example to terraform.tfvars and fill in your values.${NC}"
    exit 1
fi

# Load variables from terraform.tfvars
PROJECT_ID=$(grep -v '^#' terraform.tfvars | grep '^project_id ' | cut -d '"' -f 2)
REGION=$(grep -v '^#' terraform.tfvars | grep '^region ' | cut -d '"' -f 2)
IMAGE_TAG=$(grep -v '^#' terraform.tfvars | grep '^image_tag ' | cut -d '"' -f 2)

if [ -z "$PROJECT_ID" ]; then
    echo -e "${RED}Error: project_id not found in terraform.tfvars${NC}"
    exit 1
fi

if [ -z "$REGION" ]; then
    REGION="asia-northeast1"
fi

if [ -z "$IMAGE_TAG" ]; then
    IMAGE_TAG="latest"
fi

echo -e "${YELLOW}Project ID: ${PROJECT_ID}${NC}"
echo -e "${YELLOW}Region: ${REGION}${NC}"
echo -e "${YELLOW}Image Tag: ${IMAGE_TAG}${NC}"
echo ""

# Set GCP project
echo -e "${GREEN}Setting GCP project...${NC}"
gcloud config set project "${PROJECT_ID}"

# Enable required APIs
echo -e "${GREEN}Enabling required GCP APIs...${NC}"
gcloud services enable \
    run.googleapis.com \
    artifactregistry.googleapis.com \
    secretmanager.googleapis.com \
    cloudbuild.googleapis.com

# Initialize Terraform (if not already initialized)
if [ ! -d ".terraform" ]; then
    echo -e "${GREEN}Initializing Terraform...${NC}"
    terraform init
fi

# Create Artifact Registry repository (via Terraform)
echo -e "${GREEN}Planning Terraform changes...${NC}"
terraform plan -out=tfplan

echo ""
echo -e "${YELLOW}Review the plan above. Do you want to apply? (yes/no)${NC}"
read -r APPLY_CONFIRM

if [ "$APPLY_CONFIRM" != "yes" ]; then
    echo -e "${RED}Deployment cancelled.${NC}"
    exit 0
fi

echo -e "${GREEN}Applying Terraform...${NC}"
terraform apply tfplan

# Get repository name
REPO_NAME="mendoi"
IMAGE_NAME="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/mendoi-backend:${IMAGE_TAG}"

# Configure Docker authentication
echo -e "${GREEN}Configuring Docker authentication...${NC}"
gcloud auth configure-docker "${REGION}-docker.pkg.dev"

# Build Docker image
echo -e "${GREEN}Building Docker image...${NC}"
cd ..
docker build -t "${IMAGE_NAME}" .

# Push Docker image
echo -e "${GREEN}Pushing Docker image to Artifact Registry...${NC}"
docker push "${IMAGE_NAME}"

# Update Cloud Run service (re-deploy)
cd terraform
echo -e "${GREEN}Updating Cloud Run service...${NC}"
terraform apply -auto-approve

# Get Cloud Run URL
CLOUD_RUN_URL=$(terraform output -raw cloud_run_url)

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${YELLOW}Cloud Run URL: ${CLOUD_RUN_URL}${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Update iOS app APIClient with the Cloud Run URL"
echo -e "2. Test the /health endpoint: curl ${CLOUD_RUN_URL}/health"
echo -e "3. Test the API endpoints with Firebase ID token"
echo ""
