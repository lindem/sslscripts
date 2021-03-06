#! /bin/bash

echo "This will create a CA folder infrastructure. Press Ctrl+C to abort"
read

mkdir -p ca/private
mkdir -p ca/cert
touch ca/database.txt
echo "01" > ca/serial
cat << EOCONFIG > ca/ca.cnf
[ ca ]
default_ca = CA_default

[ CA_default ]
dir = ./
certs = $dir/certs
crl_dir = $dir/crl
database = $dir/database.txt
new_certs_dir = $dir/newcerts
certificate = $dir/certs/cacert.pem
serial = $dir/serial
private_key = $dir/private/cakey.pem
x509_extensions = usr_cert
default_days = 3650
default_md = sha1
preserve = no
policy = policy_match

[ policy_match ]
countryName = match
stateOrProvinceName = match
localityName = match
organizationName = match
organizationalUnitName = optional
commonName = supplied
emailAddress = optional

[ policy_cn_email ]
commonName = supplied
emailAddress = supplied

[ req ]
default_bits = 4096
default_keyfile = cakey.pem
distinguished_name = req_distinguished_name
attributes = req_attributes
x509_extensions = v3_ca
string_mask = utf8only
req_extensions = v3_req

[ req_attributes ]

[ req_distinguished_name ]
countryName = Country Name (2 letter code)
countryName_default = DE
countryName_min = 2
countryName_max = 2
stateOrProvinceName = State or Province Name (full name)
stateOrProvinceName_default = Germany
localityName = Locality Name (city, district)
organizationName = Organization Name (company)
organizationalUnitName = Organizational Unit Name (department, division)
commonName = Common Name (hostname, FQDN, IP, or your name)
commonName_max = 64
emailAddress = Email Address
emailAddress_max = 40

[ usr_cert ]
basicConstraints= CA:FALSE
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer:always
nsComment = ''OpenSSL Generated Certificate''
subjectAltName=email:copy
issuerAltName=issuer:copy

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment

[ v3_ca ]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer:always
basicConstraints = CA:TRUE
EOCONFIG

echo "Folder structure has been made. Edit ca/ca.conf, and call make-ca-cert.sh"
echo "to make a ca certificate."