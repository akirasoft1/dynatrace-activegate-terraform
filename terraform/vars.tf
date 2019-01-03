# variables file
# contains the aws access credentials, aws amis per region, aws instance type depending on ActiveGate sizing 
# the Dynatrace download URL retrieved from Dynatrace UI
#
# originally Raffaele Talarico
# 08/29/2017
# repurposed for Dynatrace ActiveGate by Michael Villiger
# 01/02/2018

#############
# DYNATRACE #
#############

# DYNATRACE_DOWNLOAD_URL should be placed in terraform.tfvars along with security/region information
# URL is obtained from the ActiveGate deployment page or created programmatically in the following format:
# Dynatrace URL for saas tenants is https://<environmentid>.live.dynatrace.com/api/v1/deployment/installer/gateway/unix/latest?Api-Token=<API_TOKEN>&arch=x86&flavor=default
# Dynatrace URL for sprint tenents is https://<environmentid>.sprint.dynatracelabs.com/api/v1/deployment/installer/gateway/unix/latest?Api-Token=<API_TOKEN>&arch=x86&flavor=default
# Dynatrace URL for Managed tenants is https://<YourDynatraceServerHost:Port>/e/<environmentID>/api/v1/deployment/installer/gateway/unix/latest?Api-Token=<API_TOKEN>&arch=x86&flavor=default
variable "DYNATRACE_DOWNLOAD_URL" {}

#######
# AWS #
#######

# all access keys, ssh keys, and region information should be in the terraform.tfvars file that is created before terraform apply
variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {}

variable "AWS_KEYPAIR_NAME" {}

variable "AWS_PRIVATE_KEY" {}

variable "emailtag" {}

#specify the root volume size. default is 20GB
variable "ROOT_VOLUME_SIZE" {
default = 10
}

#here are the latest Ubuntu 16.04 AMI IDs already listed for each region 
variable "AMIS"{
	type = "map"
	default = {
		us-east-1 = "ami-059eeca93cf09eebd"
		us-east-2 = "ami-0782e9ee97725263d"
		us-west-1 = "ami-0ad16744583f21877"
		us-west-2 = "ami-0e32ec5bc225539f5"
		eu-west-1 = "ami-0773391ae604c49a4"
		eu-west-2 = "ami-061a2d878e5754b62"
		eu-west-3 = "ami-075b44448d2276521"
		sa-east-1 = "ami-0318cb6e2f90d688b"
		eu-central-1 = "ami-086a09d5b9fa35dc7"
		ap-northeast-1 = "ami-06c43a7df16e8213c"
		ap-northeast-2 = "ami-0e0f4ff1154834540"
		ap-northeast-3 = "ami-0e8fa3dc3fa30d1da"
		ap-south-1 = "ami-04ea996e7a3e7ad6b"
		ap-southeast-1 = "ami-0eb1f21bbd66347fe"
		ap-southeast-2 = "ami-0789a5fb42dcccc10"
		ca-central-1 = "ami-0f2cb2729acf8f494"
	}
}

variable "DYNATRACE_SIZING" {
#check the "AWS_INSTANCE_TYPE" values in the next block for the available options
#please keep in mind that even using the trial sizing you will incur in expenses
#you can comment the following line to be prompted for the dynatrace-sizing
	default = "default"
}

variable "AWS_INSTANCE_TYPE" {
#the available Dynatrace Sizings available are listed here:
#https://help.dynatrace.com/dynatrace-managed/introduction/what-are-the-hardware-and-software-requirements/
#since Dynatrace Managed it's more memory consuming you can opt to choose the memory optimized EC2 instance types
#by specifying trial-memory, small-memory, medium-memory or large-memory
	type = "map"
	default = {
		default = "t3.medium" 
		minimum = "t3.small"
		large = "t3.large"
		xlarge = "t3.xlarge"
		t2default = "t2.medium"
		t2minmum = "t2.small"
	}
}



