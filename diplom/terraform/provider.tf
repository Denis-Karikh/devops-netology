# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

    backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "denis-test"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "YCAJEoBrZlm-Ko69QtYB1YY3O"
    secret_key = "YCM9v53S8FlPydCOeWl4fQuCAEpsK3kOpEni5j0y"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token = "${var.token}"
  cloud_id  = "${var.cloud_id}"
  folder_id = "${var.folder_id}"
}
