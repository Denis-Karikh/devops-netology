1)
~~~bash
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: 57e43ec2-32f3-40c3-affe-20eb577b3913
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Fri, 31 Dec 2021 11:59:24 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-fra19144-FRA
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1640951964.039622,VS0,VE92
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=b3ad848f-a7a4-5212-26c3-248cca2ebc19; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly


Connection closed by foreign host.
~~~
Вернулся код 301 Moved Permanently - это означает, что запрошенный ресурс был перемещен в новое месторасположение, на которое указывает location: https://stackoverflow.com/questions.

2)Status Code: 200 

Завершено: 2.03 сек.
Запросить URL: https://stackoverflow.com/ 399 мс

3)188.235.156.10

4)
~~~bash
root@vagrant:/home/vagrant# whois 188.235.156.10 | grep ^descr
descr:          CJSC "ER-Telecom Holding" Saratov branch
descr:          Saratov, Russia
descr:          Individual PPPoE customers
descr:          TM DOM.RU, Saratov ISP
descr:          CJSC "ER-Telecom Holding" Saratov branch
descr:          Saratov, Russia
descr:          TM DOM.RU, Saratov ISP
root@vagrant:/home/vagrant# whois 188.235.156.10 | grep ^origin
origin:         AS50543
~~~
5)
~~~bash
root@vagrant:/home/vagrant# traceroute -An 8.8.8.8 -I
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  10.0.2.2 [*]  0.270 ms  0.243 ms  0.239 ms
 2  192.168.1.254 [*]  1.615 ms  1.692 ms  1.730 ms
 3  10.204.9.254 [*]  5.685 ms  5.681 ms  5.592 ms
 4  10.204.253.9 [*]  6.448 ms  6.528 ms  6.583 ms
 5  10.204.252.33 [*]  5.982 ms  6.072 ms  6.164 ms
 6  109.195.17.252 [AS50543]  6.718 ms  3.260 ms  4.066 ms
 7  109.195.24.30 [AS50543]  4.577 ms  5.877 ms  5.909 ms
 8  72.14.215.165 [AS15169]  20.688 ms  20.836 ms  20.859 ms
 9  72.14.215.166 [AS15169]  22.001 ms  21.886 ms  22.115 ms
10  142.251.53.67 [AS15169]  21.194 ms  21.098 ms  21.256 ms
11  108.170.250.83 [AS15169]  21.598 ms  21.680 ms  18.692 ms
12  * * 209.85.249.158 [AS15169]  43.836 ms
13  216.239.57.222 [AS15169]  38.183 ms  38.243 ms  38.260 ms
14  72.14.237.199 [AS15169]  40.429 ms  40.763 ms  40.557 ms
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  * * *
24  8.8.8.8 [AS15169]  37.687 ms  39.646 ms  39.744 ms
~~~
6)
~~~bash
12. AS15169  209.85.249.158                                                  63.7%   103   39.2  41.2  38.3  48.6   2.7
~~~
7)
~~~bash
dns.google.             10800   IN      NS      ns1.zdns.google.
dns.google.             10800   IN      NS      ns4.zdns.google.
dns.google.             10800   IN      NS      ns3.zdns.google.
dns.google.             10800   IN      NS      ns2.zdns.google.
~~~
~~~bash
root@vagrant:/home/vagrant# dig dns.google A +noall +answer
dns.google.             36      IN      A       8.8.4.4
dns.google.             36      IN      A       8.8.8.8
~~~
8)
~~~bash
root@vagrant:/home/vagrant# dig -x 8.8.4.4 +noall +answer
4.4.8.8.in-addr.arpa.   22118   IN      PTR     dns.google.
root@vagrant:/home/vagrant# dig -x 8.8.8.8 +noall +answer
8.8.8.8.in-addr.arpa.   19856   IN      PTR     dns.google.
~~~
