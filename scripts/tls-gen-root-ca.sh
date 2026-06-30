#!/bin/bash

set -euo pipefail

TLS_DIR="$(git rev-parse --show-toplevel)/tls"
OUT_CA="${TLS_DIR}/ca"

DAYS_CA="${DAYS_CA:-3650}"
CA_SUBJECT="${CA_SUBJECT:-/C=FR/O=CDA/OU=IoT/CN=CDA Gateway Root CA}"

mkdir -p "${OUT_CA}"

if [[ -f "${OUT_CA}/gateway-ca.key" || -f "${OUT_CA}/gateway-ca.crt" ]]; then
	echo "CA material already exists in ${OUT_CA}.\nAborting."
	exit 1
fi

echo "Generating root CA…"

openssl genrsa -out "${OUT_CA}/gateway-ca.key" 4096
openssl req -x509 -new -nodes \
	-key "${OUT_CA}/gateway-ca.key" \
	-sha256 -days "${DAYS_CA}" \
	-subj "${CA_SUBJECT}" \
	-out "${OUT_CA}/gateway-ca.crt"

chmod 600 "${OUT_CA}/gateway-ca.key" || true

echo "Done."
echo "CA key : ${OUT_CA}/gateway-ca.key"
echo "CA cert : ${OUT_CA}/gateway-ca.crt"
echo "Public copy for nginx/client trust : ${TLS_DIR}/gateway-ca.crt"
