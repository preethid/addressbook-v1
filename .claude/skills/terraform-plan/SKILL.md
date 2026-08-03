---
name: terraform-plan
description: Run `terraform plan` for this repo's EC2 infrastructure in terraform/. Use when the user asks to plan, preview, dry-run, or check what Terraform would change for the addressbook EC2 deployment.
---

The Terraform configuration for this project's EC2 deployment lives in `terraform/` at the repo
root (`provider.tf`, `variables.tf`, `main.tf`, `outputs.tf`). It provisions a security group and an
EC2 instance (Amazon Linux 2, default VPC) prepped with Docker for Jenkins/CodeDeploy to deploy the
addressbook app onto.

## Steps

1. `cd terraform`
2. Check whether `.terraform/` exists; if not (or if `provider.tf`/`versions` changed), run
   `terraform init -input=false` first.
3. `terraform validate` — surface any config errors before planning.
4. Determine the required variables:
   - `key_name` — an existing EC2 key pair name in the target region. If not already known from
     context, ask the user, or list available key pairs with
     `aws ec2 describe-key-pairs --region <region> --query 'KeyPairs[].KeyName' --output text`.
   - `ssh_allowed_cidr` — defaults to `0.0.0.0/0` if unset. Don't silently leave this open; flag it.
   - Other variables (`aws_region`, `instance_type`, `app_port`, `project_name`) have sensible
     defaults — only override if the user specifies.
5. Run the plan, saving the output for a possible later apply:
   ```
   terraform plan -var="key_name=<value>" [-var="ssh_allowed_cidr=<cidr>"] -out=tfplan
   ```
6. Summarize the result for the user: resource counts (add/change/destroy), and call out anything
   security-sensitive (e.g. SSH open to `0.0.0.0/0`, unexpected destroys).
7. Do **not** run `terraform apply` unless the user explicitly asks — planning and applying are
   separate, confirmed actions.
