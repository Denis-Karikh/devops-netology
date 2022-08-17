# Самоконтроль выполнения задания

>1. Где расположен файл с `some_fact` из второго пункта задания?
>
```console
./group_vars/all/examp.yml
```
>
>2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?
>
```console
ansible-playbook  -i inventory/test.yml site.yml 
```
>
>1. Какой командой можно зашифровать файл?
>
```console
ansible-vault encrypt group_vars/el/examp.yml
```
>
>2. Какой командой можно расшифровать файл?
>
```console
ansible-vault decrypt group_vars/el/examp.yml
```
>
>3. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?
>
```console
ansible-vault view group_vars/el/examp.yml
```
>
>4. Как выглядит команда запуска `playbook`, если переменные зашифрованы?
>
```console
ansible-playbook  -i inventory/prod.yml site.yml --ask-vault-pass
```
>
>5. Как называется модуль подключения к host на windows?
>
```text
winrm, pspr
```
>
>6. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh
>
```console
ansible-doc -t connection ssh
```
>
>7. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?
>
```text
remote_user
```
