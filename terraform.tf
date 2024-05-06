terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.117.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "> 3.3"
    }
  }
}
