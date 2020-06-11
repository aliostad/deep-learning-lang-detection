#!/usr/bin/env sh

#
# Public: Creates a data file and a public/private keypair.
#
# sample_data/data          - binary file with 1024 bytes of random data
# sample_data/test.key      - PEM-encoded 2048-bit RSA private key
# sample_data/test.crt      - PEM-encoded self-signed certificate/public key
# sample_data/test.keystore - Java keystore with that same keypair aliased as 'test_key'
#
# Exit status is 0 if everything worked as intended.


# Create fake data
head -c 1024 /dev/urandom > sample_data/data

# Generate new key pair
openssl req -new -newkey rsa:2048 -days 730 -nodes -x509 -subj "/C=US/ST=SomeState/L=AnyTown/O=SimpleTest/OU=TESTING ONLY/CN=key" -outform PEM -keyout sample_data/test.key -out sample_data/test.crt

# Create a Java Keystore
openssl pkcs12 -export -in sample_data/test.crt -inkey sample_data/test.key -out sample_data/test.pkcs12 -passout pass:unsafepass
keytool -importkeystore -srckeystore ./sample_data/test.pkcs12 -srcstoretype PKCS12 -srcstorepass unsafepass -deststoretype JKS -destkeystore sample_data/test.keystore -deststorepass unsafepass -srcalias 1 -destalias test_key -noprompt
rm sample_data/test.pkcs12

# Run each tool
node node/signature.js sign   sample_data/data sample_data/test.key sample_data/data.sig
node node/signature.js verify sample_data/data sample_data/data.sig sample_data/test.crt
