output "ext_ipv4"{
    value = yandex_vpc_address.addr.external_ipv4_address[0].address
}
