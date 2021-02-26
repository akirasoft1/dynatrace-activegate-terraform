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
variable "DYNATRACE_DOWNLOAD_URL" {
}

#######
# GCP #
#######

# all access keys, ssh keys, and region information should be in the terraform.tfvars file that is created before terraform apply
variable "GCP_PROJECT" {
}

variable "GCP_REGION" {
}

variable "GCP_ZONE" {
}

variable "GCP_PUBLIC_KEY" {  
}

variable "GCP_PRIVATE_KEY" {
}

# #specify the root volume size. default is 20GB
# variable "ROOT_VOLUME_SIZE" {
#   default = 10
# }


variable "DYNATRACE_SIZING" {
  #please keep in mind that even using the trial sizing you will incur in expenses
  #you can comment the following line to be prompted for the dynatrace-sizing
  default = "default"
}

variable "GCP_INSTANCE_TYPE" {
  #the available Dynatrace Sizings available are listed here:
  #https://help.dynatrace.com/dynatrace-managed/introduction/what-are-the-hardware-and-software-requirements/
  #since Dynatrace Managed it's more memory consuming you can opt to choose the memory optimized EC2 instance types
  #by specifying trial-memory, small-memory, medium-memory or large-memory
  type = map(string)
  default = {
    default   = "e2-medium"
  }
}

variable "API_TOKEN" {  
}