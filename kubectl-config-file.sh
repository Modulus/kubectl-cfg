#!/bin/bash

print_help(){
    echo "usage example:"
    echo "kubectl cfg list"
    echo "Kubectl cfg use minikube.conf"
}

test_apps(){
    apps=("ls", "ln", "find", "grep", "cut", "echo")

    all_ok = true;
    for app in $apps
    do
        if [ -x "$(command -v $app) 2> /dev/null" ];
        then
            all_ok = false;
        fi
    done
    return $all_ok
}

list_all_configs(){
    files=$(find ~/.kube -maxdepth 1 -type f)

    for file in $files
    do
        start=${file%/*}//
        length_start=${#start}
        length_full=${#file}
        name=$(echo $file | cut -c$length_start-$length_full)
        if [[ $name != *".log"* ]] && [[ $name != *"backup"* ]]
        then
            echo "$name"
        fi
    done
}

list_active_config(){
    ls -la ~/.kube | grep "config ->"
}

change_config(){
    config=~/.kube/$1
    echo "changing config to $config"
    ln -sf $config ~/.kube/config
}

if [ -z "$1" ]
then
    list_active_config
elif [[ "$1" == "use" ]] && [[ ! -z "$2" ]]
then
    change_config $2
    list_active_config
    exit 0

elif [[ "$1" == "list" ]]
then
    list_all_configs
    exit 0
else
    echo "Missing arguments"
    print_help
    exit 0
fi


