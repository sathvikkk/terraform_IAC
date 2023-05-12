terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.53.1"
    }
  }
}

provider "google" {
  credentials = "${file("")}"
  project = ""
  region = ""
  zone = ""

}
