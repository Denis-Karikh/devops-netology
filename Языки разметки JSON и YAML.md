1)
```json
  { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```
2)
```python
import socket
import sys
import json
import yaml


servces = ['drive.google.com', 'mail.google.com', 'google.com']

def get_ips_for_host(host):
    try:
        ips = socket.gethostbyname_ex(host)
    except socket.gaierror:
        ips=[]
    return ips

def set_ip(ip, name):
    dicti = {name : ip}
    yaml_ar = [{name : ip}]
    f_json = json.dumps(dicti, sort_keys=True, indent=4)
    f_yaml = yaml.dump(yaml_ar)
    with open(f"previp{name}.txt", 'w') as fi:
        fi.write(ip)
    with open(f"previp{name}.json", 'w') as fi:
        fi.write(f_json)
    with open(f"previp{name}.yaml", 'w') as fi:
        fi.write(f_yaml)


def get_ip(name):
    try:
        with open(f"previp{name}.txt", 'r') as fi:
            return fi.read().strip()
    except Exception:
        return 'Fist Run'

for ser in servces:
    previp = get_ip(ser)
    ips = get_ips_for_host(ser)
    if ips[2][0] != previp:
        sys.stdout.write(f"[ERROR] {ser} IP mismatch: {previp} {ips[2][0]}\n")
        set_ip(ips[2][0], ser)

    else:
        sys.stdout.write(f"{ser} - {ips[2][0]}\n")
```
```
C:\Users\Денис\AppData\Local\Microsoft\WindowsApps\python3.9.exe D:/Netology2/test3.py
[ERROR] drive.google.com IP mismatch: Fist Run 64.233.161.194
[ERROR] mail.google.com IP mismatch: Fist Run 142.251.1.17
[ERROR] google.com IP mismatch: Fist Run 173.194.220.113
```
```json
{
    "drive.google.com": "64.233.161.194"
}
```
```yaml
- drive.google.com: 64.233.161.194
```

