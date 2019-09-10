#!/bin/bash

print_help(){
    echo "usage example:"
    echo "kubectl cfg list"
    echo "Kubectl cfg use minikube.conf"
}

test_for_apps(){
    apps=("ls" "ln" "find" "grep" "cut" "echo")

    all_ok=1;
    for app in $apps
    do
        if [ "$(command -v $app) 2> /dev/null" ];
        then
            $all_ok=0;
            echo "OK"
        else
            echo "NOT OK"
        fi
    done

    echo "Checking"
    echo "$all_ok"
    if [ $all_ok == 0 ]; then
       echo "Missing one of these programs: ${apps[@]}"
       echo "Consult your package manager to install"
    fi

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

run(){
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
}

has_apps=test_for_apps

if [ $has_apps == 1 ]; then
    run

else
    exit 1
fi


