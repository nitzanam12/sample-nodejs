# sample-nodejs

A sample Node.js application deployed to Amazon EKS. This repository contains the Dockerfile, GitHub Actions pipeline, and Terraform infrastructure.

- App: https://app.nitzan-assignment.com/my-app
- GitOps repo: https://github.com/nitzanam12/sample-nodejs-gitops

## CI/CD

1. Pull requests to main run npm audit, Semgrep, Docker build, and Trivy scanning.
2. After a merge to main, the scanned image is pushed to private ECR with a commit SHA tag. Semantic Release handles versioning based on Conventional Commits.
3. A GitHub App opens a pull request to update image.tag in the GitOps repository.
4. Once that PR is merged, Argo CD syncs the change and Kubernetes rolls out the new image.

The image is built once per workflow run and passed between jobs as a GitHub Actions artifact. Deployment requires a GitOps PR merge; the rollout itself is automatic.

## Infrastructure

Terraform in the infra/ directory manages:

- A VPC across two availability zones, with public ALB subnets and private EKS node subnets.
- EKS with two managed worker nodes, and a private ECR repository.
- IAM roles for GitHub OIDC and the AWS Load Balancer Controller's Pod Identity.
- An ACM certificate for app.nitzan-assignment.com.

The ALB serves HTTPS and redirects HTTP to HTTPS. Only /my-app and /about are routed publicly. Health checks use /ready directly against the application targets.

## Security

- GitHub Actions use pinned action commits, vulnerability scans, and short-lived AWS credentials through OIDC.
- Cross-repository updates use a GitHub App token limited to the GitOps repository.
- The runtime image uses Node.js 22 distroless and a non-root user. Kubernetes enforces a read-only root filesystem and restrictive security settings.
- ECR image tags are immutable. Deployments reference specific commit SHAs.