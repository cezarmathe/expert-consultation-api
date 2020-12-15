# export-consultation - deployment

This is a Terraform module for deploying the **Expert Consultation** project.

## Requirements

The **AWS** provider expects to find the following environment variables set with according values:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`

This module takes in 5 variables:

- `db_instance_type` (default: `db.t2.micro`)
- `client_image` (default: `legal-client`)
- `api_image` (default: `expert-consultation-api`)
- `db_username`
- `db_password`

## Sample `main.auto.tfvars` file

```ini
db_username = "sampleusername"
db_password = "SamplePassword1."
```
