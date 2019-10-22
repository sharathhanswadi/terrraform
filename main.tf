
provider "google" {
  credentials =  "flask-app-211918-256610-61d6c8f0e5b1.json"
  project = "flask-app-211918-256610"
  region      = "us-west-1"
}


resource "google_project_service" "project" {
  project = "flask-app-211918-256610"
  service = "iam.googleapis.com"

  disable_dependent_services = true
}

resource "random_id" "instance_id" {
  byte_length = 8
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
  name         = "flask-vm-${random_id.instance_id.hex}"
  machine_type = "g1-small"
  zone         = "us-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20170328"
    }
  }

  // Make sure flask is installed on all new instances for later steps
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}
