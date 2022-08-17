#!/bin/bash

declare -a arr=("ubuntu" "fedora" "centos")

for i in "${arr[@]}"
do
    docker run -d --name $i nkiselyov/"${i}py" sleep 600000
done

ansible-playbook  -i inventory/prod.yml site.yml --ask-vault-pass

docker stop $(docker ps -q)
