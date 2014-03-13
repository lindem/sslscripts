#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/functions.sh

check_ca_folders
if [[ $? -ne 0 ]]
then
    echo "You are not inside a folder structure with which this script can work."
    echo "You can create one by calling make-ca-folders.sh."
    exit 1
fi

find_openssl
if [[ $? -ne 0 ]]
then
    echo "the openssl program wasn't found. You can store its location in the"
    echo "OPENSSL environment variable."
    exit 1
else
    if [[ ! -z $VERBOSE ]]
    then
        echo "openssl found in location $OPENSSL."
    fi
fi

if [[ $# -lt 1 ]]
then
    echo "no name prefix supplied (you may supply one as a command line"
    echo "parameter)."
    echo "please type one on the line below (no spaces allowed):"
    read PREFIX
else
    echo "using $PREFIX as prefix."
    PREFIX=$1
fi

mkdir -p certs/key certs/csr certs/signed

CACERTFILE="ca/cert/cacert.pem"
CAKEYFILE="ca/private/cakey.pem"
CASERIALFILE="ca/serial"
KEYFILE="certs/key/$PREFIX-private-key.pem"
CSRFILE="certs/csr/$PREFIX-csr.pem"
CERTFILE="certs/signed/$PREFIX-signed-cert.pem"
P12FILE="certs/signed/$PREFIX-signed-cert.p12"

echo "---> generating private key in $KEYFILE"
$OPENSSL genrsa -out $KEYFILE 4096
break_on_error $? "while creating private key"

echo "---> generating certificate signing request"
$OPENSSL req -new -key $KEYFILE -out $CSRFILE
break_on_error $? "while generating CSR"

echo "---> signing certificate with CA $CACERTFILE and key $CAKEYFILE for ten years"
$OPENSSL x509 -days 3650 -CA $CACERTFILE -CAkey $CAKEYFILE -req -in $CSRFILE \
    -outform PEM -out $CERTFILE -CAserial $CASERIALFILE
break_on_error $? "while signing certificate"

echo "---> converting the certificate to pkcs format (not needed for webserver)"
$OPENSSL pkcs12 -export -in $CERTFILE -inkey $KEYFILE -certfile $CACERTFILE \
    -out $P12FILE
break_on_error $? "while converting to p12"