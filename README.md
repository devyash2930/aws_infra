# Autonomous Software Recovery System

Autonomous Software Recovery System is a self-healing reliability platform that detects runtime failures, plans remediation with retrieval-augmented reasoning (RAG), generates code fixes using an LLM, and redeploys services automatically on AWS.

The system was designed to close the reliability gap between detection and recovery by reducing manual incident response steps.

## Problem Statement

Even when code passes CI/CD, production failures still occur due to:

- Runtime state drift
- Dependency/API instability
- Slow manual mean time to recovery (MTTR)

This project automates the full loop from fault detection to validated redeployment.

## High-Level Architecture

```text
Application (ECS/Fargate + ALB)
  -> CloudWatch Logs (fault marker)
  -> Fault Router Lambda (incident context extraction)
  -> Backboard.io (RAG remediation strategy)
  -> GitHub Tool Lambda + Gemini (patch generation + git push)
  -> GitHub Actions CI/CD
      - Docker build
      - ECR push
      - ECS task/service update
      - Blue/Green deploy on Fargate
      - Health verification
```

## Core Components

### 1. Application Layer

- Flask-based application running on ECS/Fargate behind an ALB
- Controlled fault injection route: `/test-fault`
- Emits deterministic fault markers to CloudWatch logs (for repeatable recovery tests)

### 2. Detection Layer

- CloudWatch log stream monitoring
- Fault Router Lambda filters for known fault markers
- Captures and packages incident logs + metadata as recovery context

### 3. Strategy Layer (RAG)

- Backboard.io retrieves related historical incidents and known fix patterns
- Produces a structured remediation plan
- Uses deterministic knowledge first, with reasoning escalation only when needed

### 4. Execution Layer

- GitHub Tool Lambda receives remediation plan
- Gemini transforms plan into repository code changes
- Commits and pushes patch to GitHub for full auditability

### 5. Recovery Loop

- GitHub Actions pipeline triggers automatically on patch push
- Builds container image and pushes to ECR
- Updates ECS service/task definition
- Performs blue/green Fargate rollout
- Runs final health checks to confirm recovery

## What Makes It Different

- **Decoupled strategy and execution:** planning and code mutation are isolated for safety
- **Whitelisted operations:** automation is restricted to approved Git/recovery actions
- **Deterministic validation:** repeatable fault injection through `/test-fault`
- **End-to-end observability:** each recovery step is logged and auditable

## Performance

- **88% faster recovery** in demo runs (measured from fault trigger to Fargate redeploy)

## Tech Stack

- **Cloud:** AWS ECS, Fargate, Lambda, CloudWatch, ECR, ALB
- **Application:** Python, Flask
- **AI/RAG:** Backboard.io, Gemini 1.5 Pro
- **DevOps:** GitHub, GitHub Actions, Docker

## End-to-End Flow

1. A controlled fault is triggered from `/test-fault` (or occurs naturally in production).
2. CloudWatch captures logs with a known marker.
3. Fault Router Lambda detects the marker and assembles incident context.
4. Backboard.io generates a remediation strategy from retrieval + reasoning.
5. GitHub Tool Lambda calls Gemini to convert strategy to concrete code edits.
6. The patch is committed and pushed to GitHub.
7. GitHub Actions builds and deploys the updated container to ECS/Fargate.
8. Health checks verify service recovery.

## Repository Structure (Suggested)

```text
.
├── app/                        # Flask service and fault injection route
├── infra/                      # IaC (Terraform/CloudFormation/CDK)
├── lambda/
│   ├── fault-router/           # CloudWatch trigger + context packaging
│   └── github-tool/            # RAG plan ingestion + LLM patch execution
├── .github/workflows/          # CI/CD workflows
├── docs/                       # Architecture, runbooks, test reports
└── README.md
```

## Setup Guide

Update this section with your exact implementation details. A practical baseline:

### Prerequisites

- AWS account with permissions for ECS/Fargate, Lambda, CloudWatch, ECR, IAM
- Docker installed
- GitHub repository with Actions enabled
- Python 3.10+ for Flask app/lambda tooling
- API access/configuration for Backboard.io and Gemini

### Environment Variables (Example)

```bash
AWS_REGION=us-east-1
ECS_CLUSTER=your-cluster
ECS_SERVICE=your-service
ECR_REPOSITORY=your-repo
FAULT_LOG_GROUP=/ecs/cream-task
FAULT_MARKER=INTENTIONAL_INVALID_SQL
BACKBOARD_API_KEY=...
GEMINI_API_KEY=...
GITHUB_TOKEN=...
GITHUB_REPO=org/repo
```

### Deployment Steps (Typical)

1. Provision cloud resources (`infra/`)
2. Deploy Flask app to ECS/Fargate
3. Configure CloudWatch log subscription/event trigger to Fault Router Lambda
4. Configure Backboard.io knowledge base and remediation templates
5. Deploy GitHub Tool Lambda with least-privilege IAM
6. Configure GitHub Actions workflow for build/deploy/verification
7. Run a deterministic recovery test via `/test-fault`

## Safety and Governance

- Least-privilege IAM roles for both Lambdas
- Whitelisted recovery commands only
- Full Git commit history for every AI-generated change
- CI gates + health checks before stable traffic cutover

## Testing Strategy

- **Unit tests:** parser, marker detection, remediation plan formatting
- **Integration tests:** lambda-to-lambda handoff, GitHub API operations
- **Resilience tests:** repeated `/test-fault` injections under load
- **Deployment tests:** blue/green success + rollback validation

## Operational Metrics to Track

- MTTR (trigger -> healthy deploy)
- Detection latency (log emission -> router trigger)
- Strategy generation latency
- Patch success rate
- Deployment success rate
- False positive/negative incident detection rate

## Future Improvements

- Multi-service incident correlation
- Automated rollback for low-confidence fixes
- Human approval mode for high-risk patches
- Expanded fault taxonomy and playbook coverage
- Cost-aware remediation policy routing

## Team

Team Cream&Onion (HACK_NCSTATE 2026)



# Steps to replicate

## Services
- ECS Fargate
- ECR
- Lambda
- Load Balancer
- IAM
- CloudWatch

## Deploy

cd terraform
terraform init
terraform apply

## Build & Push Docker Image

cd docker
./build.sh

## Destroy

terraform destroy
