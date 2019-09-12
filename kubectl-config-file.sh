#!/bin/bash

config_folder="$HOME/.kube/"
config_file="config"
config_full_path="${config_folder}${config_file}"

print_help(){
    echo "usage example:"
    echo "kubectl cfg list"
    echo "Kubectl cfg use minikube.conf"
}
#
# Checks if ~/.kube/config is a link or an empty file.
# 1 -> Is either a link or empty file or file does not exist
# 0 -> File exists is not empty and not a link
test_config_file_is_link_or_empty(){
    if ! [[ -f $config_full_path ]] || [[ -L "$config_full_path" ]]  
    then
        echo 1;
    else
        echo 0;
    fi
}

test_for_apps(){
    local apps=("ls" "ln" "find" "grep" "cut" "echo" "nein");
    local has_apps=1;
    for app in $apps
    do
        if ! [  -x "$(command -v $app)" ];
        then
            has_apps=0;
        fi
    done
    echo $has_apps
}

list_all_configs(){
    local files=$(find ~/.kube -maxdepth 1 -type f)

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
    if ! [[ -f $config_full_path ]] 
    then
        echo "$config_full_path does not exist... Cannot list active config"
    else
        ls -la $config_folder | grep "config ->"
    fi
}

change_config(){
    config=~/.kube/$1
    echo "changing config to: $config"
    echo "Symlink: $config_full_path"
    ln -sf $config $config_full_path
}

# Test if required shell commands are present
has_apps=$(test_for_apps)

# Check if config file for kube config is link or empty.
# If it is a regular file with text, execution will halt
config_file_is_link_or_empty=$(test_config_file_is_link_or_empty)


if  [[ $config_file_is_link_or_empty == 0 ]]
then
    echo "$config_full_path is not a symbolic link. Or file has contents. Take backup of the contents and delete the file to continue "
    exit 1
else
    if [[ $has_apps == 1 ]]; then
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

    else
        echo "Missing one of the commands: ls ln find grep cut echo. Consult your package manager for how to install these"
        exit 1
    fi
fi




