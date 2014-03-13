#!/bin/bash

## checks for any number of files if these files exist.
## returns the number of errors.
function check_files () {
    local ret=0
    for file in $@
    do
        if [ ! -e $file ]
        then
            ret=`expr $ret + 1`
            if [[ ! -z $VERBOSE ]]
            then
                echo "$file is missing"
            fi
        fi
    done
    # zero is "all files present"
    return $ret
}

## checks if the current folder has all the files in place to make the scripts
## in this bundle work.
function check_ca_folders () {
    check_files ca/ca.cnf \
        ca/serial \
        ca/database.txt \
        ca/cert/cacert.pem \
        ca/private/cakey.pem
}

## tries to find openssl and stores it in $OPENSSL. if the value ending up in
## $OPENSSL is not the name of an executable file, this function returns 1,
## 0 otherwise.
function find_openssl () {
    if [[ -z $OPENSSL ]]
    then
        OPENSSL=$(which openssl)
    fi
    if [[ -x $OPENSSL ]]
    then
        return 0
    else
        return 1
    fi
}

function break_on_error () {
    if [[ $1 -ne 0 ]]
    then
        echo "=========="
        echo "=========="
        echo $2
        echo "(exiting script)"
        exit 1
    fi
}