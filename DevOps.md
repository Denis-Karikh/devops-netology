- Процесс установки и настройки ufw
```shell
#установка ufw
sudo apt install ufw
#включить firewall:
sudo ufw enable
#открыть порты для входящих подключений:
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
#разрешить соединение ко всем портам сервера с конкретного IP-адреса:
sudo ufw allow from 127.0.0.1
```
- Процесс установки и выпуска сертификата с помощью hashicorp vault
```shell
denis@denis-VirtualBox:~$ sudo su
[sudo] пароль для denis: 
root@denis-VirtualBox:/home/denis# vault server -dev -dev-root-token-id root
==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.17.5
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: true, enabled: false
           Recovery Mode: false
                 Storage: inmem
                 Version: Vault v1.9.3
             Version Sha: 7dbdd57243a0d8d9d9e07cd01eb657369f8e1b8a
```

```shell
C:\Users\Денис>ssh denis@192.168.1.84
denis@192.168.1.84's password:
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.13.0-28-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

217 updates can be applied immediately.
130 of these updates are standard security updates.
Чтобы просмотреть дополнительные обновления выполните: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Wed Feb 16 22:56:54 2022 from 192.168.1.66
denis@denis-VirtualBox:~$ sudo su
[sudo] пароль для denis:
#первоначальные настройки vault
root@denis-VirtualBox:/home/denis# export VAULT_ADDR=http://127.0.0.1:8200
root@denis-VirtualBox:/home/denis# export VAULT_TOKEN=root
#pki в vault для корневых сертификатов
root@denis-VirtualBox:/home/denis# vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
#установили максимальный срок действия сертификатов
root@denis-VirtualBox:/home/denis# vault secrets tune -max-lease-ttl=87600h pki
Success! Tuned the secrets engine at: pki/
#генерация корневого сертификата (root CA)
root@denis-VirtualBox:/home/denis# vault write -field=certificate pki/root/generate/internal \
>      common_name="example.com" \
>      ttl=87600h > CA_cert.crt
#Определяем пути сохранения сертификатов
root@denis-VirtualBox:/home/denis# vault write pki/config/urls \
>      issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
>      crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls
```
```shell
#создание промежуточного сертификата (intermediate CA)
root@denis-VirtualBox:/home/denis# vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
#срок действия для промежуточных сертификатов
root@denis-VirtualBox:/home/denis# vault secrets tune -max-lease-ttl=43800h pki_int
Success! Tuned the secrets engine at: pki_int/
#создание промежуточного сертификата
root@denis-VirtualBox:/home/denis# vault write -format=json pki_int/intermediate/generate/internal \
>      common_name="example.com Intermediate Authority" \
>      | jq -r '.data.csr' > pki_intermediate.csr
#подписать промежуточный сертификат корневым
root@denis-VirtualBox:/home/denis# vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
>      format=pem_bundle ttl="43800h" \
>      | jq -r '.data.certificate' > intermediate.cert.pem
#Сохраняем его в Vault
root@denis-VirtualBox:/home/denis# vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
```
```shell
#Создание роли
root@denis-VirtualBox:/home/denis# vault write pki_int/roles/example-dot-com \
>      allowed_domains="example.com" \
>      allow_subdomains=true \
>      max_ttl="720h"
Success! Data written to: pki_int/roles/example-dot-com
#создание сертификата сервера сроком жизни 30 дней
root@denis-VirtualBox:/home/denis# vault write -format=json pki_int/issue/example-dot-com \
>     common_name="test.example.com" \
>     ttl="720h" > test.crt
#сохранение pem и key
root@denis-VirtualBox:/home/denis# cat test.crt | jq -r .data.certificate > vault.test.example.com.crt.pem
root@denis-VirtualBox:/home/denis# cat test.crt | jq -r .data.ca_chain[0] >> vault.test.example.com.crt.pem
root@denis-VirtualBox:/home/denis# cat test.crt | jq -r .data.private_key > vault.test.example.com.crt.key
```
#Так же корневой сертификат добавлен в доверенные в Windows
- Процесс установки и настройки сервера nginx
```shell
#Установил пакеты, необходимые для подключения apt-репозитория
root@denis-VirtualBox:/home/denis# apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring
Чтение списков пакетов… Готово
Построение дерева зависимостей
Чтение информации о состоянии… Готово
Уже установлен пакет lsb-release самой новой версии (11.1.0ubuntu2).
lsb-release помечен как установленный вручную.
Уже установлен пакет curl самой новой версии (7.68.0-1ubuntu2.7).
Уже установлен пакет ubuntu-keyring самой новой версии (2020.02.11.4).
ubuntu-keyring помечен как установленный вручную.
Следующие НОВЫЕ пакеты будут установлены:
  gnupg2
Следующие пакеты будут обновлены:
  ca-certificates
Обновлено 1 пакетов, установлено 1 новых пакетов, для удаления отмечено 0 пакетов, и 215 пакетов не обновлено.
Необходимо скачать 4 584 B/150 kB архивов.
После данной операции объём занятого дискового пространства возрастёт на 50,2 kB.
Хотите продолжить? [Д/н] y
Пол:1 http://ru.archive.ubuntu.com/ubuntu focal-updates/universe amd64 gnupg2 all 2.2.19-3ubuntu2.1 [4 584 B]
Получено 4 584 B за 0с (14,0 kB/s)
Предварительная настройка пакетов …
(Чтение базы данных … на данный момент установлено 188060 файлов и каталогов.)
Подготовка к распаковке …/ca-certificates_20210119~20.04.2_all.deb …
Распаковывается ca-certificates (20210119~20.04.2) на замену (20210119~20.04.1) …
Выбор ранее не выбранного пакета gnupg2.
Подготовка к распаковке …/gnupg2_2.2.19-3ubuntu2.1_all.deb …
Распаковывается gnupg2 (2.2.19-3ubuntu2.1) …
Настраивается пакет gnupg2 (2.2.19-3ubuntu2.1) …
Настраивается пакет ca-certificates (20210119~20.04.2) …
Updating certificates in /etc/ssl/certs...
0 added, 1 removed; done.
Обрабатываются триггеры для man-db (2.9.1-1) …
Обрабатываются триггеры для ca-certificates (20210119~20.04.2) …
Updating certificates in /etc/ssl/certs...
0 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
#импортировал официальный ключ, используемый apt для проверки подлинности пакетов
root@denis-VirtualBox:/home/denis# curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
>       | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1561  100  1561    0     0   5134      0 --:--:-- --:--:-- --:--:--  5118
#Проверка отпечатка ключа.
root@denis-VirtualBox:/home/denis# gpg --dry-run --quiet --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
gpg: источник блока ключей '/root/.gnupg/pubring.kbx': Нет такого файла или каталога
pub   rsa2048 2011-08-19 [SC] [годен до: 2024-06-14]
      573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
uid                      nginx signing key <signing-key@nginx.com>

#Для подключения apt-репозитория для стабильной версии nginx, выполнил следующую команду
root@denis-VirtualBox:/home/denis# echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
>   http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
>       | sudo tee /etc/apt/sources.list.d/nginx.list
deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg]   http://nginx.org/packages/ubuntu focal nginx
#Для использования пакетов из нашего репозитория вместо распространяемых в дистрибутиве, настройте закрепление
root@denis-VirtualBox:/home/denis# echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
>       | sudo tee /etc/apt/preferences.d/99nginx
Package: *
Pin: origin nginx.org
Pin: release o=nginx
Pin-Priority: 900

#Обновляем списки пакетов
root@denis-VirtualBox:/home/denis# apt update
Сущ:1 http://ru.archive.ubuntu.com/ubuntu focal InRelease
Пол:2 http://ru.archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Пол:3 http://nginx.org/packages/ubuntu focal InRelease [3 584 B]
Пол:4 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Пол:5 http://ru.archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Пол:6 http://nginx.org/packages/ubuntu focal/nginx amd64 Packages [15,7 kB]
Пол:7 http://ru.archive.ubuntu.com/ubuntu focal-updates/main i386 Packages [604 kB]
Пол:8 http://ru.archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [1 580 kB]
Пол:9 https://apt.releases.hashicorp.com focal InRelease [9 495 B]
Пол:10 http://ru.archive.ubuntu.com/ubuntu focal-updates/main Translation-en [304 kB]
Пол:11 http://ru.archive.ubuntu.com/ubuntu focal-updates/main amd64 DEP-11 Metadata [279 kB]
Пол:12 http://ru.archive.ubuntu.com/ubuntu focal-updates/main DEP-11 64x64 Icons [98,3 kB]
Пол:13 http://ru.archive.ubuntu.com/ubuntu focal-updates/main amd64 c-n-f Metadata [14,7 kB]
Пол:14 http://ru.archive.ubuntu.com/ubuntu focal-updates/restricted amd64 Packages [810 kB]
Пол:15 http://ru.archive.ubuntu.com/ubuntu focal-updates/restricted Translation-en [115 kB]
Пол:16 http://ru.archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [904 kB]
Пол:17 http://ru.archive.ubuntu.com/ubuntu focal-updates/universe i386 Packages [667 kB]
Пол:18 http://ru.archive.ubuntu.com/ubuntu focal-updates/universe amd64 DEP-11 Metadata [391 kB]
Пол:19 http://ru.archive.ubuntu.com/ubuntu focal-updates/universe amd64 c-n-f Metadata [20,1 kB]
Пол:20 http://ru.archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 DEP-11 Metadata [940 B]
Пол:21 http://ru.archive.ubuntu.com/ubuntu focal-backports/main amd64 DEP-11 Metadata [7 972 B]
Пол:22 http://ru.archive.ubuntu.com/ubuntu focal-backports/universe amd64 DEP-11 Metadata [23,7 kB]
Пол:23 http://ru.archive.ubuntu.com/ubuntu focal-backports/universe amd64 c-n-f Metadata [716 B]
Пол:24 https://apt.releases.hashicorp.com focal/main amd64 Packages [48,4 kB]
Пол:25 http://security.ubuntu.com/ubuntu focal-security/main i386 Packages [379 kB]
Пол:26 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [1 247 kB]
Пол:27 http://security.ubuntu.com/ubuntu focal-security/main Translation-en [219 kB]
Пол:28 http://security.ubuntu.com/ubuntu focal-security/main amd64 DEP-11 Metadata [40,6 kB]
Пол:29 http://security.ubuntu.com/ubuntu focal-security/restricted amd64 Packages [757 kB]
Пол:30 http://security.ubuntu.com/ubuntu focal-security/restricted Translation-en [108 kB]
Пол:31 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [678 kB]
Пол:32 http://security.ubuntu.com/ubuntu focal-security/universe i386 Packages [534 kB]
Пол:33 http://security.ubuntu.com/ubuntu focal-security/universe Translation-en [116 kB]
Пол:34 http://security.ubuntu.com/ubuntu focal-security/universe amd64 DEP-11 Metadata [66,3 kB]
Пол:35 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 DEP-11 Metadata [2 464 B]
Получено 10,4 MB за 3с (3 351 kB/s)
Чтение списков пакетов… Готово
Построение дерева зависимостей
Чтение информации о состоянии… Готово
Может быть обновлено 222 пакета. Запустите «apt list --upgradable» для их показа.
N: Пропускается получение настроенного файла «nginx/binary-i386/Packages», так как репозиторий «http://nginx.org/packages/ubuntu focal InRelease» не поддерживает архитектуру «i386»
#Устанавливаем nginx
root@denis-VirtualBox:/home/denis# apt install nginx
Чтение списков пакетов… Готово
Построение дерева зависимостей
Чтение информации о состоянии… Готово
Следующие пакеты будут УДАЛЕНЫ:
  libnginx-mod-http-image-filter libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream nginx-common
  nginx-core
Следующие пакеты будут обновлены:
  nginx
Обновлено 1 пакетов, установлено 0 новых пакетов, для удаления отмечено 6 пакетов, и 221 пакетов не обновлено.
Необходимо скачать 879 kB архивов.
После данной операции объём занятого дискового пространства возрастёт на 983 kB.
Хотите продолжить? [Д/н] y
Пол:1 http://nginx.org/packages/ubuntu focal/nginx amd64 nginx amd64 1.20.2-1~focal [879 kB]
Получено 879 kB за 1с (1 142 kB/s)
dpkg: nginx-core: имеются проблемы с зависимостями, но по вашему указанию
он всё равно будет удалён:
 nginx зависит от nginx-core (<< 1.18.0-0ubuntu1.2.1~) | nginx-full (<< 1.18.0-0ubuntu1.2.1~) | nginx-light (<< 1.18.0-0ubuntu1.2.1~) | nginx-extras (<< 1.18.0-0ubuntu1.2.1~), однако:
  Пакет nginx-core будет удалён.
  Пакет nginx-full не установлен.
  Пакет nginx-light не установлен.
  Пакет nginx-extras не установлен.
 nginx зависит от nginx-core (>= 1.18.0-0ubuntu1.2) | nginx-full (>= 1.18.0-0ubuntu1.2) | nginx-light (>= 1.18.0-0ubuntu1.2) | nginx-extras (>= 1.18.0-0ubuntu1.2), однако:
  Пакет nginx-core будет удалён.
  Пакет nginx-full не установлен.
  Пакет nginx-light не установлен.
  Пакет nginx-extras не установлен.
 nginx зависит от nginx-core (<< 1.18.0-0ubuntu1.2.1~) | nginx-full (<< 1.18.0-0ubuntu1.2.1~) | nginx-light (<< 1.18.0-0ubuntu1.2.1~) | nginx-extras (<< 1.18.0-0ubuntu1.2.1~), однако:
  Пакет nginx-core будет удалён.
  Пакет nginx-full не установлен.
  Пакет nginx-light не установлен.
  Пакет nginx-extras не установлен.
 nginx зависит от nginx-core (>= 1.18.0-0ubuntu1.2) | nginx-full (>= 1.18.0-0ubuntu1.2) | nginx-light (>= 1.18.0-0ubuntu1.2) | nginx-extras (>= 1.18.0-0ubuntu1.2), однако:
  Пакет nginx-core будет удалён.
  Пакет nginx-full не установлен.
  Пакет nginx-light не установлен.
  Пакет nginx-extras не установлен.

(Чтение базы данных … на данный момент установлено 188065 файлов и каталогов.)
Удаляется nginx-core (1.18.0-0ubuntu1.2) …
Удаляется libnginx-mod-http-image-filter (1.18.0-0ubuntu1.2) …
dpkg: nginx-common: имеются проблемы с зависимостями, но по вашему указанию
он всё равно будет удалён:
 libnginx-mod-stream зависит от nginx-common (= 1.18.0-0ubuntu1.2).
 libnginx-mod-mail зависит от nginx-common (= 1.18.0-0ubuntu1.2).
 libnginx-mod-http-xslt-filter зависит от nginx-common (= 1.18.0-0ubuntu1.2).

Удаляется nginx-common (1.18.0-0ubuntu1.2) …
(Чтение базы данных … на данный момент установлено 188035 файлов и каталогов.)
Подготовка к распаковке …/nginx_1.20.2-1~focal_amd64.deb …
Распаковывается nginx (1.20.2-1~focal) на замену (1.18.0-0ubuntu1.2) …
(Чтение базы данных … на данный момент установлено 188053 файла и каталога.)
Удаляется libnginx-mod-stream (1.18.0-0ubuntu1.2) …
Удаляется libnginx-mod-http-xslt-filter (1.18.0-0ubuntu1.2) …
Удаляется libnginx-mod-mail (1.18.0-0ubuntu1.2) …
Настраивается пакет nginx (1.20.2-1~focal) …
Устанавливается новая версия файла настройки /etc/default/nginx …
Устанавливается новая версия файла настройки /etc/init.d/nginx …
Устанавливается новая версия файла настройки /etc/logrotate.d/nginx …
Устанавливается новая версия файла настройки /etc/nginx/mime.types …
Устанавливается новая версия файла настройки /etc/nginx/nginx.conf …
Обрабатываются триггеры для man-db (2.9.1-1) …
Обрабатываются триггеры для systemd (245.4-4ubuntu3.11) …
```
```shell
#директория, куда сохранил сертификат и ключ
root@denis-VirtualBox:/home/denis# mkdir /etc/nginx/conf
root@denis-VirtualBox:/home/denis# cp vault.test.example.com.crt.pem /etc/nginx/conf/
root@denis-VirtualBox:/home/denis# cp vault.test.example.com.crt.key /etc/nginx/conf/
#создал директорию, куда выложу стартовую страницу
root@denis-VirtualBox:/home/denis# mkdir /data
root@denis-VirtualBox:/home/denis# chown denis /data
root@denis-VirtualBox:/home/denis# mkdir /data/www
root@denis-VirtualBox:/home/denis# echo 'Ho-ho-ho!' > /data/www/index.html
#файл конфигурации nginx
root@denis-VirtualBox:/home/denis# sudo nano /etc/nginx/nginx.conf
```
```shell
```shell
user  nginx;
worker_processes  auto;
error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  65;
    #gzip  on;
    include /etc/nginx/conf.d/*.conf;
    server {
        location / {
            root /data/www;
        }
        listen              443 ssl;
        server_name         test.example.com;
        ssl_certificate     /etc/nginx/conf/vault.test.example.com.crt.pem;
        ssl_certificate_key /etc/nginx/conf/vault.test.example.com.crt.key;
        ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers         HIGH:!aNULL:!MD5;
    }
}
```
```shell
#запуск nginx
root@denis-VirtualBox:/home/denis# root@denis-VirtualBox:/home/denis# service nginx start
root@denis-VirtualBox:/home/denis# nginx -s reload
#дать права на директорию с сертификатами пользователю vagrant
root@denis-VirtualBox:/home/denis# chown denis /etc/nginx/conf
```
#файл для генерации нового сертификата:
```shell
#!/bin/bash
export VAULT_ADDR='http://127.0.0.1:8200'
vault write -format=json pki_int/issue/example-dot-com \
   common_name="test.example.com" \
   ttl="720h" > /home/denis/test.crt
cat /home/denis/test.crt | jq -r .data.certificate > /etc/nginx/conf/vault.test.example.com.crt.pem
cat /home/denis/test.crt | jq -r .data.ca_chain[0] >> /etc/nginx/conf/vault.test.example.com.crt.pem
cat /home/denis/test.crt | jq -r .data.private_key > /etc/nginx/conf/vault.test.example.com.crt.key
nginx -s reload
```
#Настройка Crontab
```shell
root@denis-VirtualBox:/home/denis# crontab -e
48 00 18 * * /home/vagrant/new_cer >> /home/vagrant/log 2>&1
#Далее переименовали cert.sh в > cert так как в crontab работает без расширений.
```shell
root@denis-VirtualBox:/home/denis# grep CRON /var/log/syslog
Feb 18 00:02:01 denis-VirtualBox CRON[14495]: (root) CMD (   test -x /etc/cron.daily/popularity-contest && /etc/cron.daily/popularity-contest --crond)
Feb 18 00:17:01 denis-VirtualBox CRON[14607]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Feb 18 00:48:01 denis-VirtualBox CRON[14890]: (root) CMD (/home/denis/cert >> /home/denis/logs 2>&1)
root@denis-VirtualBox:/home/denis# ps -ax | grep nginx
  10423 ?        Ss     0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
  13121 ?        S      0:00 nginx: worker process
  15006 pts/1    S+     0:00 grep --color=auto nginx
root@denis-VirtualBox:/home/denis# ls -l /etc/nginx/conf/
итого 8
-rw-r--r-- 1 root root 1675 фев 18 00:48 vault.test.example.com.crt.key
-rw-r--r-- 1 root root 2567 фев 18 00:48 vault.test.example.com.crt.pem
root@denis-VirtualBox:/home/denis# 
```
