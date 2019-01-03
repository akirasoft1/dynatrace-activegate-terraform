# instance file
# it contains the aws instance details
# originally Raffaele Talarico
# 08/29/2017
# based on: https://github.com/raffaele-talarico/dynatrace-terraform-aws
# repurposed for ActiveGate by Michael Villiger
# 1/2/2019

# for further details about aws_instance available arguments 
# check out https://www.terraform.io/docs/providers/aws/r/instance.html
# for further details about Dynatrace ActiveGate install parameters:
# check out https://www.dynatrace.com/support/help/deploy-dynatrace/activegate/installation/customize-installation-for-activegate/
# for further details around Dynatrace ActiveGate configuration parameters:
# check out https://www.dynatrace.com/support/help/deploy-dynatrace/activegate/configuration/configure-activegate/

# This ActiveGate will only be used for executing plugins so ingress will only be allowed on SSH. 
# Note, best practices typically specify a bastion host for ssh access, we are forgoing that here.
resource "aws_security_group" "terraformactivegate" {
  name        = "terraformactivegate"
  description = "Allow SSH inbound traffic for Dynatrace ActiveGate"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dynatraceactivegate" {
	
	vpc_security_group_ids = ["${aws_security_group.terraformactivegate.id}"]
	key_name = "${var.AWS_KEYPAIR_NAME}"

	#ami ID and instance type are defined in the vars file 
  	ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  	instance_type = "${lookup(var.AWS_INSTANCE_TYPE, var.DYNATRACE_SIZING)}"
	
	#EC2 instance root volume size
	root_block_device {
        volume_size = "${var.ROOT_VOLUME_SIZE}"
   	}

	#specify a tag (optional) for the EC2 instance, we utilize email to tag our instance owners
	tags {
    	  email = "${var.emailtag}"
  	}
	
# The following block downloads and executes the Dynatrace ActiveGate installer
# and configures the ActiveGate to run the CloudFoundry plugin and not accept agent traffic
#/var/lib/dynatrace/gateway/config	
	provisioner "remote-exec" {
    		inline = [
      			"sudo wget -O /tmp/activegate.sh \"${var.DYNATRACE_DOWNLOAD_URL}\"",
      			"cd /tmp/",
				    "sudo /bin/sh /tmp/activegate.sh"
    		]
	#the connection block defines the connection params to ssh into the newly created EC2 instance 
			connection {
				type = "ssh"
				user = "ubuntu"
				private_key = "${var.AWS_PRIVATE_KEY}"
				timeout = "3m"
				agent = false
			}
  	}
# the below block loads the persistant custom config that enables the CF plugin and disables the AG handling agent traffic
 	provisioner "file" {
    source      = "conf/config.properties"
    destination = "/var/lib/dynatrace/gateway/config/config.properties"
  }

# after loading custom config, we need to restart the AG	
	provisioner "remote-exec" {
    		inline = [
      			"sudo service dynatracegateway forcestop",
      			"sudo service dynatracegateway start"
    		]
	#the connection block defines the connection params to ssh into the newly created EC2 instance 
			connection {
				type = "ssh"
				user = "ubuntu"
				private_key = "${var.AWS_PRIVATE_KEY}"
				timeout = "3m"
				agent = false
			}
  	}	
}

#a little trick to show the complete url with the public_dns of the created node
output "public_ip_for_ssh" {
  value = "${aws_instance.dynatraceactivegate.public_dns}"
}
