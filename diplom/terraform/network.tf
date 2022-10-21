# Создание сети
resource "yandex_vpc_network" "denis-diplom" {
  name = "network"
}

resource "yandex_vpc_address" "addr" {
  name = "static_ip"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

# Создаем правило маршрутизации - все потоки на int_ip
resource "yandex_vpc_route_table" "nat-int" {
  network_id = "${yandex_vpc_network.denis-diplom.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.int_ip
  }
}

# Создание подсетей в разных зонах доступности
resource "yandex_vpc_subnet" "subnet-1" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.denis-diplom.id}"
  route_table_id = "${yandex_vpc_route_table.nat-int.id}"
  v4_cidr_blocks = ["192.168.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet-2" {
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.denis-diplom.id}"
  route_table_id = "${yandex_vpc_route_table.nat-int.id}"
  v4_cidr_blocks = ["192.168.2.0/24"]
}
