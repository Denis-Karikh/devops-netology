# devops-netology
1)chdir("/tmp")
2)/usr/share/misc/magic.mgc
3)Находим через процесс которые пишет в удаленный файл, и командой echo '' >/proc/... чистим файл 
Если брать пример из лекции то /tmp/do_not_delete_me (deleted)
4) Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом.
5) PID    COMM               FD ERR PATH
784    vminfo              4   0 /var/run/utmp
578    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
578    dbus-daemon        18   0 /usr/share/dbus-1/system-services
578    dbus-daemon        -1   2 /lib/dbus-1/system-services
578    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
6)      Part of the utsname information is also accessible  via  /proc/sys/ker‐
       nel/{ostype, hostname, osrelease, version, domainname}.
7)&& -  условный оператор, 
;  - разделитель последовательных команд
test -d /tmp/some_dir; echo Hi - echo отработает в любом случаи после операции test -d /tmp/some_dir
test -d /tmp/some_dir && echo Hi - echo отработает в случаи если первое часть выполниться.
&&  вместе с set -e- не имеет смысла, так как при ошибке , выполнение команд прекратиться
8)-e прерывает выполнение исполнения при ошибке любой команды кроме последней в последовательности 
-x вывод трейса простых команд 
-u неустановленные/не заданные параметры и переменные считаются как ошибки, с выводом в stderr текста ошибки и выполнит завершение неинтерактивного вызова
-o pipefail возвращает код возврата набора/последовательности команд, ненулевой при последней команды или 0 для успешного выполнения команд.
Расширенное логирование.
9)S*(S,S+,Ss,Ssl,Ss+) - Процессы ожидающие завершения (спящие с прерыванием "сна")
I*(I,I<) - фоновые(бездействующие) процессы ядра

