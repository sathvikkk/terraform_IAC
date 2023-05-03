terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.53.1"
    }
  }
}

provider "google" {
  credentials = "${file("sinuous-transit-377210-fed835d25221.json")}"
  project = "sinuous-transit-377210"
  region = "us-central1"
  zone = "us-central1-a"

}