# dynatrace-activegate-terraform

## What is this?

A set of terraform files for deploying either one ActiveGate or multiple ActiveGates across several environments

## How do I use it?

Obviously you'll need to clone this repo, then, depending on if you are deploying a single ActiveGate or Multiple ActiveGates, you will need to change into the appropriate directory:

1. `cd` into the proper directory:
    - [terraform/](terraform/)
    - [terraforming-multiple-ags/](terraforming-multiple-ags/)
1. Create [`terraform.tfvars`](/README.md#var-file) file
1. Run terraform apply:
  ```bash
  terraform init
  terraform plan -out=activegate.tfplan
  terraform apply activegate.tfplan
  ```

# Var File
```hcl
emailtag = "email@domain.com"
AWS_ACCESS_KEY = "AWS ACCESS KEY GOES HERE"
AWS_SECRET_KEY = "AWS SECRET KEY GOES HERE"
DYNATRACE_DOWNLOAD_URLS = [
"https://<environmentid1>.live.dynatrace.com/api/v1/deployment/installer/gateway/unix/latest?Api-Token=<API_TOKEN1>&arch=x86&flavor=default",
"https://<environmentid2>.live.dynatrace.com/api/v1/deployment/installer/gateway/unix/latest?Api-Token=<API_TOKEN2>&arch=x86&flavor=default",
"https://<environmentid3>.live.dynatrace.com/api/v1/deployment/installer/gateway/unix/latest?Api-Token=<API_TOKEN3>&arch=x86&flavor=default",
"https://<environmentid4>.live.dynatrace.com/api/v1/deployment/installer/gateway/unix/latest?Api-Token=<API_TOKEN4>&arch=x86&flavor=default"
]
AWS_REGION = "aws-region"
AWS_KEYPAIR_NAME = "somekeypair"
AWS_PRIVATE_KEY = <<EOF
-----BEGIN RSA PRIVATE KEY-----
PUT PRIVATE KEY HERE
-----END RSA PRIVATE KEY-----
EOF
```
### Variables

- emailtag: email to be included in the tags of a host. Internally we utilize email addresses to track owners of instances. If you use something else, alter the variable here, tags block in instance.tf and vars.tf to reference whatever param you might want to use instead.
- AWS_ACCESS_KEY **(required)** Your Amazon access_key to deploy the ActiveGate(s)
- AWS_SECRET_KEY: **(required)** Your Amazon secret_key to deploy the ActiveGate(s)
- DYNATRACE_DOWNLOAD_URL(S): **(required)** URL is obtained from the ActiveGate deployment page or created programmatically in the following format:
    - Dynatrace URL for saas tenants is https://<environmentid>.live.dynatrace.com/api/v1/deployment/installer/gateway/unix/latest?Api-Token=<API_TOKEN>&arch=x86&flavor=default
    - Dynatrace URL for sprint tenants is https://<environmentid>.sprint.dynatracelabs.com/api/v1/deployment/installer/gateway/unix/latest?Api-Token=<API_TOKEN>&arch=x86&flavor=default
    - Dynatrace URL for Managed tenants is https://<YourDynatraceServerHost:Port>/e/<environmentID>/api/v1/deployment/installer/gateway/unix/latest?Api-Token=<API_TOKEN>&arch=x86&flavor=default
- AWS_REGION: **(required)** AWS region where you'd like the ActiveGate(s) to run
- AWS_KEYPAIR_NAME: **(required)** pre-existing keypair to use to ssh to the ActiveGate(s)
- AWS_PRIVATE_KEY: **(required)** Corresponding private key to the previously existing keypair name mentioned above

### Cleanup

to destroy the ActiveGate(s), simply run the following:
  ```bash
  terraform destroy
  ```
