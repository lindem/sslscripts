#!/bin/bash


# if the location of the openssl binary is defined in the OPENSSL envvar, prefer
# that. If not, try to locate it with which.
if [[ -z "${OPENSSL+x}" ]]
then
    OPENSSL=`which openssl`
fi

# if $OPENSSL is executable, everything is fine. If not, exit here.
if [[ ! -x $OPENSSL ]]
then
    echo "the openssl command was not found. You can supply its location with"
    echo "the environment variable OPENSSL"
    exit 1;
fi

if [[ -e ca/ca.cnf && -e ca/private && -e ca/cert ]]
then
    echo "making certificate using your ca/ca.cnf. Ctrl+C to abort, enter to"
    echo "proceed."
    read
    openssl req -new -x509 -nodes -days 3650 -config ca/ca.cnf -keyform PEM \
        -keyout ca/private/cakey.pem -outform PEM -out ca/cert/cacert.pem
    if [ $? -ne 0 ]
    then
        echo "---> An error occured."
    else
        echo "---> All done."
    fi

else
    echo "the folder structure was not found. Please run this script in the"
    echo "directory where you ran make-ca-folders.sh."
    exit 1
fi