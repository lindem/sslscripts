#!/bin/bash

## this script is "just a wrapper" to create a CSR, because I am tired to look
## up how openssl works.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/functions.sh

find_openssl
break_on_error $? "openssl not found."

if [[ -z $PREFIX ]]
then
    echo "no name prefix supplied (you may supply one as PREFIX env var)"
    echo "please type one on the line below (no spaces allowed):"
    read PREFIX
else
    echo "using $PREFIX as prefix."
fi

mkdir -p certs/csr certs/key

KEYFILE="certs/key/$PREFIX-private-key.pem"
CSRFILE="certs/csr/$PREFIX-csr.pem"

$OPENSSL genrsa -out $KEYFILE 4096
$OPENSSL req -new -key $KEYFILE -out $CSRFILE

echo "private key file is in $KEYFILE."
echo "the matching CSR is in $CSRFILE."