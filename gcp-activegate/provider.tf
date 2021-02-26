# provider file
# it contains the aws credentials and region details, provided separately in the variables file
#
# originally Raffaele Talarico
# 08/29/2017
# updated Michael Villiger
# 01/02/2019

# instead of using static access and secret key variables
# you can also use a shared credentials file
#   shared_credentials_file = "/Users/myUser/.aws/credentials"
#   profile                 = "myAwsProfile"
#
# further details for all providers here:
# https://www.terraform.io/docs/configuration/providers.html

provider "google" {
  project = var.GCP_PROJECT
  region  = var.GCP_REGION
  zone    = var.GCP_ZONE
}