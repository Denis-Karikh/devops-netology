1)[![imageban](https://i7.imageban.ru/thumbs/2022.01.23/0111fcb1160bdc89b9a1062f7db6fbc9.png)](https://imageban.ru/show/2022/01/23/0111fcb1160bdc89b9a1062f7db6fbc9/png)
2)Скрин прекреплен
3)Скрин прекреплен
4)Клонируем репозиторий testssl:
```shell
git clone --depth 1 https://github.com/drwetter/testssl.sh.git
```
Задаем права запуска на файл testssl.sh:

```shell
vagrant@vagrant:~/testssl.sh$ chmod +x ./testssl.sh
```

Проверяем произвольный сайт на уязвимости:


<details>
<summary>Раскрыть</summary>

```shell
./testssl.sh -U --sneaky https://www.cisco.com
###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/
    (2dce751 2021-12-09 17:03:57 -- )
      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!
       Please file bugs @ https://testssl.sh/bugs/
###########################################################
 Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
 on vagrant:./bin/openssl.Linux.x86_64
 (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")
 Start 2021-12-09 19:21:47        -->> 2.23.130.48:443 (www.cisco.com) <<--
 Further IP addresses:   2001:2030:21:1b1::b33 2001:2030:21:1ae::b33 
 rDNS (2.23.130.48):     a2-23-130-48.deploy.static.akamaitechnologies.com.
 Service detected:       HTTP
 Testing vulnerabilities 
 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
 ROBOT                                     Server does not support any cipher suites that use RSA key transport
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     VULNERABLE (NOT ok), DoS threat (6 attempts)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              No fallback possible (OK), no protocol below TLS 1.2 offered
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=B26A300351FE254C585211A21050A5B194FD3DE7E5BBBDC700885062437E9BFF could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     not vulnerable (OK), no SSL3 or TLS1
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)
 Done 2021-12-09 19:22:13 [  30s] -->> 2.23.130.48:443 (www.cisco.com) <<--
```
</details>

5)
```shell
apt install openssh-server  
ssh-keygen  
ssh-copy-id root@192.168.1.81 -> yes  (192.168.1.81 - ip адрес аналогиченого сервера)  
ssh 'root@192.168.72.149'  
Соединение установлено
```
 6)
