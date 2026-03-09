# InfraKitchen Test Modules

This folder contains a clean set of Terraform/OpenTofu modules intended for validating InfraKitchen behavior

## Modules

- `01-variable-types`: Validates InfraKitchen handling of multiple Terraform variable types.
- `02-long-running`: Validates InfraKitchen stability during a long-running `apply`.
- `03-intentional-failure`: Validates InfraKitchen behavior when a module fails intentionally.
- `04-parent-child-outputs`: Validates parent-child module output wiring and inheritance behavior.
- `05-terraform-opentofu-compat`: Validates that the same module runs consistently on both Terraform and OpenTofu.

## How To Validate In InfraKitchen

InfraKitchen runs OpenTofu (`tofu`) during dry-run, apply, destroy, and output extraction. Use this flow for each module:

1. Import the repository/module path as a template source code version.
2. Create a resource (and parent resource first when required).
3. Run dry-run and verify the plan can be generated.
4. Run provision and verify status moves to `provisioned`.
5. Verify expected outputs are extracted and visible in the resource outputs.
6. Run destroy and verify cleanup succeeds.

### Module Pass Criteria

- `01-variable-types`: Variables are parsed correctly, form/schema generation works, and provision uses submitted values without type errors.
- `02-long-running`: Provision stays in progress for the expected duration and completes without timeout/worker crash.
- `03-intentional-failure`: Provision fails predictably, status is set to error, and logs expose the root cause.
- `04-parent-child-outputs`: Parent outputs are available for child input mapping, and child provisioning succeeds using inherited values.
- `05-terraform-opentofu-compat`: Module provisions successfully with InfraKitchen's OpenTofu runtime and only uses shared Terraform/OpenTofu language features.

If you also want a strict dual-engine check for `05`, run the same module once with local `terraform` CLI and once with local `tofu` CLI outside InfraKitchen, then compare plan/apply/output behavior.
