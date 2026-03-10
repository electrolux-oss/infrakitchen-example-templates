# InfraKitchen Modules

This repository is split into two groups:

- `demo/`: Cloud-usable wrapper modules
- `test/`: Focused test modules for validating InfraKitchen behavior

InfraKitchen runs OpenTofu (`tofu`) during dry-run, apply, destroy, and output extraction.

## Demo Modules (`demo/`)

### AWS Chain

- `demo/01-aws-account`: Account bootstrap wrapper.
- `demo/02-aws-vpc`: VPC and subnet networking wrapper.
- `demo/03-aws-redis`: ElastiCache Redis wrapper.
- `demo/04-aws-redis-iam`: Redis IAM policy/user binding wrapper.

## Test Modules (`test/`)

- `test/01-variable-types`: Validates InfraKitchen handling of multiple Terraform variable types.
- `test/02-long-running`: Validates InfraKitchen stability during a long-running `apply`.
- `test/03-intentional-failure`: Validates InfraKitchen behavior when a module fails intentionally.
- `test/04-parent-child-outputs`: Validates parent-child module output wiring and inheritance behavior.
- `test/05-terraform-opentofu-compat`: Validates that the same module runs consistently on Terraform/OpenTofu-compatible syntax.

## How To Validate In InfraKitchen

Use this flow for any module in `demo/` or `test/`:

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
