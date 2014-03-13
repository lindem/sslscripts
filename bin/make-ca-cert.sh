#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/functions.sh

find_openssl

if [[ $? -ne 0 ]]
then
    echo "the openssl command was not found. You can supply its location with"
    echo "the environment variable OPENSSL"
    exit 1;
fi

# check for the necessary files.
check_files ca/ca.cnf \
    ca/private \
    ca/cert

if [[ $? -eq 0 ]]
then
    echo "making certificate using your ca/ca.cnf. Ctrl+C to abort, enter to"
    echo "proceed."
    read
    $OPENSSL req -new -x509 -nodes -days 3650 -config ca/ca.cnf -keyform PEM \
        -keyout ca/private/cakey.pem -outform PEM -out ca/cert/cacert.pem
    $OPENSSL x509 -in ca/cert/cacert.pem -outform der -out ca/cert/cacert-windows.crt
    if [ $? -ne 0 ]
    then
        echo "---> An error occured."
    else
        echo
        echo "you can now use make-new-cert.sh to create a signed certificate."
        echo "---> All done."
    fi
else
    echo "the folder structure was not found. Please run this script in the"
    echo "directory where you ran make-ca-folders.sh."
    exit 1
fi