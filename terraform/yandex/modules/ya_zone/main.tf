terraform {
  required_version = "= 1.7.5"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      #      version = ">= 0.73"
    }
  }
}

resource "yandex_dns_zone" "zone_dns" {
  name   = "${var.env}-zone"
  zone   = "${var.zone}."
  public = var.is_public
}

resource "yandex_dns_recordset" "dns_recs" {
  zone_id = yandex_dns_zone.zone_dns.id
  name    = "${var.dns_name}."
  type    = "A"
  ttl     = 200
  data    = var.public_ip
}