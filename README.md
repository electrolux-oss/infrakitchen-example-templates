# InfraKitchen Modules

This repository is split into three groups:

- `demo/`: Cloud-usable wrapper modules
- `dummy/`: No-cloud AWS-shaped modules (the `demo/` AWS chain plus EKS, RDS PostgreSQL and workload wiring)
- `test/`: Focused test modules for validating InfraKitchen behavior

InfraKitchen runs OpenTofu (`tofu`) during dry-run, apply, destroy, and output extraction.

## Demo Modules (`demo/`)

### Local (no cloud)

- `demo/00-dummy`: Dummy module for demonstrating plan and apply. Uses only the `random` provider and built-in `terraform_data`, so it needs no cloud provider or credentials.

### AWS Chain

- `demo/01-aws-account`: Account bootstrap wrapper.
- `demo/02-aws-vpc`: VPC and subnet networking wrapper.
- `demo/03-aws-redis`: ElastiCache Redis wrapper.
- `demo/04-aws-redis-iam`: Redis IAM policy/user binding wrapper.

## Dummy Modules (`dummy/`)

Modules `01`-`04` mirror the `demo/` AWS chain with the same variables and outputs (`04` adds a few extras); `05`-`09` add EKS and RDS PostgreSQL chains with AWS-shaped variables and outputs. Parent-child wiring can be exercised in InfraKitchen without AWS credentials. Resources are simulated with the `random` provider and built-in `terraform_data`; IDs, ARNs and endpoints are generated in AWS format from the inputs.

- `dummy/01-account`: Dummy of `demo/01-aws-account`.
- `dummy/02-vpc`: Dummy of `demo/02-aws-vpc`.
- `dummy/03-redis`: Dummy of `demo/03-aws-redis` (`vpc_id` from `dummy/02-vpc`).
- `dummy/04-redis-iam`: Dummy IAM Redis credentials for a service account, like `dummy/09-rds-postgres-credentials`; a superset of `demo/04-aws-redis-iam` inputs/outputs that adds `redis_username`, `redis_user_arn` and `connection_url` (`cluster_arn`/`iam_user_arn` (or `iam_user_read_only_arn`)/`redis_primary_endpoint` from `dummy/03-redis`, `aws_iam_role_name` from `dummy/08-eks-service-account`'s `iam_role_name`).
- `dummy/05-eks`: Dummy EKS cluster with a managed node group, IAM roles and OIDC provider (`vpc_id` from `dummy/02-vpc`, optional `admin_role_arn` from `dummy/01-account`'s `cicd_admin_role_arn`).
- `dummy/06-rds-postgres`: Dummy RDS PostgreSQL instance with subnet/parameter/security groups and a Secrets Manager-managed master password (`vpc_id` from `dummy/02-vpc`).
- `dummy/07-eks-namespace`: Dummy Kubernetes namespace with a resource quota (`cluster_name` from `dummy/05-eks`).
- `dummy/08-eks-service-account`: Dummy Kubernetes service account with an IRSA IAM role; outputs `iam_role_arn` (`cluster_name`/`oidc_provider_arn`/`oidc_issuer_url` from `dummy/05-eks`, `namespace` from `dummy/07-eks-namespace`).
- `dummy/09-rds-postgres-credentials`: Dummy IAM database credentials, like `demo/04-aws-redis-iam`: an `rds_iam` PostgreSQL user plus an `rds-db:connect` policy attached to the service account role (`aws_iam_role_name` from `dummy/08-eks-service-account`'s `iam_role_name`; `db_instance_resource_id`/`db_instance_address`/`db_instance_port`/`db_name` from `dummy/06-rds-postgres`).

## Test Modules (`test/`)

- `test/01-variable-types`: Validates InfraKitchen handling of multiple variable types.
- `test/02-long-running`: Validates InfraKitchen stability during a long-running `apply`.
- `test/03-intentional-failure`: Validates InfraKitchen behavior when a module fails intentionally.
- `test/04-parent-child-outputs`: Validates parent-child module output wiring and inheritance behavior.
- `test/05-terraform-opentofu-compat`: Validates that the same module runs consistently on Terraform/OpenTofu-compatible syntax.

## How To Validate In InfraKitchen

Use this flow for any module in `demo/`, `dummy/` or `test/`:

1. Import the template from this repo.
2. Create a resource (and parent resource first when required by module chain).
3. Run dry-run and verify the plan can be generated.
4. Run provision and verify status moves to `provisioned`.
5. Verify expected outputs are extracted and visible in resource outputs.
6. Run destroy and verify cleanup succeeds.

### Test Module Pass Criteria

- `test/01-variable-types`: Variables are parsed correctly, form/schema generation works, and provision uses submitted values without type errors.
- `test/02-long-running`: Provision stays in progress for the expected duration and completes without timeout or worker crash.
- `test/03-intentional-failure`: Provision fails predictably, status is set to error, and logs expose the root cause.
- `test/04-parent-child-outputs`: Parent outputs are available for child input mapping, and child provisioning succeeds using inherited values.
- `test/05-terraform-opentofu-compat`: Module provisions successfully with InfraKitchen's OpenTofu runtime and only uses shared Terraform/OpenTofu language features.

If you want a strict dual-engine check for `test/05-terraform-opentofu-compat`, run the same module once with local `terraform` CLI and once with local `tofu` CLI outside InfraKitchen, then compare plan/apply/output behavior.
