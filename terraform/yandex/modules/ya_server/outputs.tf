output "public_ip" {
  value = yandex_compute_instance.vm[*].network_interface[0].nat_ip_address
}

output "all_servers" {
  value = {
    for server in yandex_compute_instance.vm :
    server.name => server.network_interface.0.nat_ip_address // "vm-test-1" = "99.79.58.22"
  }
}