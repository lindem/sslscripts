# SSL Helper scripts

These scripts were created because I am too lazy to look up how openssl works
when I need to make CA, CSR, and PKCS stuff once in a blue moon.

For most people this is uninteresting.

It consists of four executable shell scripts and one script that's sourced.

To create any numbers of self-signed certificates:

```
make-ca-folders.sh # creates a folder structure used by these scripts
make-ca-cert.sh    # creates a key and ca certificate
make-new-cert.sh   # uses the ca certificate to create a new certificate.
                   # repeat as often as needed.
```

To create just a key and matching csr for having a different CA sign the csr:

```
make-csr.sh
```

The scripts will prompt for information such as prefixes for certificate and
key file names.

