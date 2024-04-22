terraform {
  required_version = "= 1.7.5"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      #      version = ">= 0.73"
    }
  }
}

provider "yandex" {
  token     = var.ya_token
  cloud_id  = var.ya_cloud_id
  folder_id = var.ya_folder_id
  zone      = var.ya_zone
}

# создаем сеть
module "network" {
  source = "../../modules/ya_network"
  env    = var.env
}

# создаем хосты
module "vm" {
  source         = "../../modules/ya_server"
  network_id     = module.network.network_id
  ssh_keys       = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  env            = var.env
  cnt            = 1 # создать 1 хост
  cnt_to_balance = 1 # один хост в балансировку
  depends_on     = [module.network]
}

# создаем записи DNS
module "dns_zone" {
  source       = "../../modules/ya_zone"
  dns_name     = "docker.deviot.ru"
  public_ip    = module.vm.public_ip
  env          = var.env
}