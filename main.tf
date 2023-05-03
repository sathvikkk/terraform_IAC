# creating a aws provider

provider "aws" {
  region = "ap-south-1"
  # profile = "sathvik"  IAm config user

} 
# for aws instance 
# for creating an aws instance

resource "aws_instance" "ubuntu-ec2" {
  ami = "ami-0caf778a172362f1c"
  # availability_zone = "ap-south-1a"
  instance_type = "t2.micro"
  # count = 1
  # key_name      = "ubuntu-ec2-key"
  
  # installing  python version in aws ec-2 using user-data

  user_data = <<-EOF
                #! /bin/bash
                sudo apt-get update 
                sudo apt-get install -y python3.9 
                sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1

  EOF

  tags = {
    Name = "Terraform"
  }
}

# for creating the volume to aws instance

resource "aws_ebs_volume" "ubuntu-vol" {
  availability_zone = aws_instance.ubuntu-ec2.availability_zone
  size              = 10

  tags = {
    Name = "extravolume"
  }
}

#  to attach extra volume to aws instance.

resource "aws_volume_attachment" "ubuntu-vol-attach" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ubuntu-vol.id
  instance_id = aws_instance.ubuntu-ec2.id
}

#  for GCP instance -------

# creating GCP instance.

resource "google_compute_instance" "ubuntu-vm" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  zone         = "us-central1-a"  


  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Request an external IP address for this interface
    }
  }
# for installing python in vm

  metadata_startup_script = "sudo apt-get update && sudo apt-get install -y python3.9 && sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1"

# <<EOF
#!/bin/bash
# sudo apt-get update
# sudo apt-get install -y python3.9
# sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
# EOF
}


# too add disk to gcp vm
resource "google_compute_disk" "attach-disk" {
  name  = "add-disk"
  type  = "pd-ssd"
  zone  = "us-central1-a"
  # image = "ubuntu-os-cloud/ubuntu-2004-lts"
  size  = 16
}

# to attach a disk to gcp vm

resource "google_compute_attached_disk" "vm-disk-attach" {
  disk     = google_compute_disk.attach-disk.id
  instance = google_compute_instance.ubuntu-vm.id
}