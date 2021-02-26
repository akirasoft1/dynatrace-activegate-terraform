# instance file
# it contains the gcp instance details

# for further details about Dynatrace ActiveGate install parameters:
# check out https://www.dynatrace.com/support/help/deploy-dynatrace/activegate/installation/customize-installation-for-activegate/
# for further details around Dynatrace ActiveGate configuration parameters:
# check out https://www.dynatrace.com/support/help/deploy-dynatrace/activegate/configuration/configure-activegate/

# This ActiveGate will only be used for executing plugins so ingress will only be allowed on SSH. 

resource "google_compute_instance" "activegate" {
  name         = "terraform-instance"
  machine_type = var.GCP_INSTANCE_TYPE[var.DYNATRACE_SIZING]


  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20210223"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${var.GCP_PUBLIC_KEY}"
  } 

 # The following block downloads and executes the Dynatrace ActiveGate installer
  # and configures the ActiveGate to run the CloudFoundry plugin and not accept agent traffic
  # && must be used to ensure entire remote-exec block will fail if individual commands fail
  provisioner "remote-exec" {
    inline = [
      "sudo wget -O /tmp/activegate.sh \"${var.DYNATRACE_DOWNLOAD_URL}\" --header=\"Authorization: Api-Token ${var.API_TOKEN}\" && cd /tmp/ && sudo /bin/sh /tmp/activegate.sh",
    ]
  #   #the connection block defines the connection params to ssh into the newly created instance 
    connection {
      host        = google_compute_instance.activegate.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = var.GCP_PRIVATE_KEY
      timeout     = "3m"
      agent       = false
    }
  }
  # the below block loads the persistant custom config that enables the CF plugin and disables the AG handling agent traffic
  # must be put in /tmp because of permissions on /var/lib/dynatrace/gateway/config/
  provisioner "file" {
    source      = "conf/custom.properties"
    destination = "/tmp/custom.properties"
    connection {
      host        = google_compute_instance.activegate.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = var.GCP_PRIVATE_KEY
      timeout     = "3m"
      agent       = false
    }
  }  
  # after moving custom config, we need to restart the AG	
  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/custom.properties /var/lib/dynatrace/gateway/config/custom.properties && sudo chown dtuserag.dtuserag /var/lib/dynatrace/gateway/config/custom.properties && sudo systemctl stop dynatracegateway && sudo systemctl start dynatracegateway",
    ]

    #the connection block defines the connection params to ssh into the newly created EC2 instance 
    connection {
      host        = google_compute_instance.activegate.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = var.GCP_PRIVATE_KEY
      timeout     = "3m"
      agent       = false
    }
  }    
}


output "ip" {
 value = google_compute_instance.activegate.network_interface.0.access_config.0.nat_ip
}

resource "google_compute_firewall" "default" {
 name    = "activegate-ssh-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["22", "9999"]
 }
}