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

provider "aws" {
	access_key = "${var.AWS_ACCESS_KEY}"
	secret_key = "${var.AWS_SECRET_KEY}"
	region = "${var.AWS_REGION}"
}
