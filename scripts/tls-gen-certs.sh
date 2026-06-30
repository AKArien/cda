#!/bin/bash

# Generate certificates for the backend gateway API proxy.
# examples:
# ./scripts/tls/gen-certs.sh --server cda.local gw-hq-01 gw-hq-02
# ./scripts/tls/gen-certs.sh gw-dev-01
#
# optional env:
# SERVER_CN=cda.local
# SERVER_DNS_EXTRA="localhost,cda.local"
# DAYS_LEAF=825

set -euo pipefail

TLS_DIR="$(git rev-parse --show-toplevel)/tls"
OUT_CA="${TLS_DIR}/ca"
OUT_SERVER="${TLS_DIR}/server"
OUT_CLIENTS="${TLS_DIR}/clients"

CA_KEY="${OUT_CA}/gateway-ca.key"
CA_CRT="${OUT_CA}/gateway-ca.crt"

# if SERVER_CN isn’t set, try to get it from .env
if [[ -z "${SERVER_CN-}" && -f "$(git rev-parse --show-toplevel)/.env" ]]; then
	source "$(git rev-parse --show-toplevel)/.env"
fi

DAYS_LEAF="${DAYS_LEAF:-825}"
SERVER_DNS_EXTRA="${SERVER_DNS_EXTRA:-localhost}"
SERVER_CN_ENV="${SERVER_CN:-}"

mkdir -p "${OUT_SERVER}" "${OUT_CLIENTS}"

if [[ ! -f "${CA_KEY}" || ! -f "${CA_CRT}" ]]; then
	echo "Missing CA files."
	echo "Expected:"
	echo "  ${CA_KEY}"
	echo "  ${CA_CRT}"
	echo "Run ./scripts/tls/gen-root-ca.sh first."
	exit 1
fi

usage() {
	echo "Usage: $0 [--server <cn>] <client-cn> [<client-cn> ...]"
	echo
	echo "Examples:"
	echo "  $0 --server cda.local gw-hq-01 gw-hq-02"
	echo "  $0 gw-dev-01"
}

issue_server_cert() {
	local cn="$1"

	echo "Generating server cert for ${cn}..."
	openssl genrsa -out "${OUT_SERVER}/${cn}.key" 2048
	openssl req -new \
		-key "${OUT_SERVER}/${cn}.key" \
		-subj "/C=FR/O=CDA/OU=Platform/CN=${cn}" \
		-out "${OUT_SERVER}/${cn}.csr"

	local ext="${OUT_SERVER}/${cn}.ext"
	{
		echo "authorityKeyIdentifier=keyid,issuer"
		echo "basicConstraints=CA:FALSE"
		echo "keyUsage=digitalSignature,keyEncipherment"
		echo "extendedKeyUsage=serverAuth"
		echo "subjectAltName=@alt_names"
		echo
		echo "[alt_names]"
		echo "DNS.1=${cn}"
		local idx=2
		IFS=',' read -r -a extra <<< "${SERVER_DNS_EXTRA}"
		for dns in "${extra[@]}"; do
			dns="$(echo "${dns}" | xargs)"
			[[ -z "${dns}" ]] && continue
			echo "DNS.${idx}=${dns}"
			idx=$((idx + 1))
		done
	} > "${ext}"

	openssl x509 -req \
		-in "${OUT_SERVER}/${cn}.csr" \
		-CA "${CA_CRT}" \
		-CAkey "${CA_KEY}" \
		-CAcreateserial \
		-out "${OUT_SERVER}/${cn}.crt" \
		-days "${DAYS_LEAF}" -sha256 \
		-extfile "${ext}"

	echo -e "\n- ${OUT_SERVER}/${cn}.crt\n\
\t- ${OUT_SERVER}/${cn}.key\n\
\t- copied to ${TLS_DIR}/server.crt and ${TLS_DIR}/server.key"
}

issue_client_cert() {
	local cn="$1"
	local gw_dir="${OUT_CLIENTS}/${cn}"
	mkdir -p "${gw_dir}"

	echo "Generating client cert for ${cn}..."
	openssl genrsa -out "${gw_dir}/${cn}.key" 2048
	openssl req -new \
		-key "${gw_dir}/${cn}.key" \
		-subj "/C=FR/O=CDA/OU=Gateway/CN=${cn}" \
		-out "${gw_dir}/${cn}.csr"

	cat > "${gw_dir}/${cn}.ext" <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=clientAuth
EOF

	openssl x509 -req \
		-in "${gw_dir}/${cn}.csr" \
		-CA "${CA_CRT}" \
		-CAkey "${CA_KEY}" \
		-CAcreateserial \
		-out "${gw_dir}/${cn}.crt" \
		-days "${DAYS_LEAF}" -sha256 \
		-extfile "${gw_dir}/${cn}.ext"

	cat "${gw_dir}/${cn}.crt" "${gw_dir}/${cn}.key" > "${gw_dir}/${cn}.pem"

	echo -e "\t- ${gw_dir}/${cn}.crt\n\
\t- ${gw_dir}/${cn}.key\n\
\t- ${gw_dir}/${cn}.pem"
}

server_cn=""
declare -a client_cns=()

while [[ "$#" -gt 0 ]]; do
	case "$1" in
		--server)
			shift
			if [[ "$#" -eq 0 || -z "${1}" || "${1}" == --* ]]; then
				echo "Missing value for argument --server"
				usage
				exit 1
			fi
			server_cn="$1"
			shift
		;;
		-h|--help)
			usage
			exit 0
		;;
		--*)
			echo "Unknown option: $1"
			usage
			exit 1
		;;
		*)
			client_cns+=("$1")
			shift
		;;
	esac
done

# Fallback to env if CLI flag is absent
if [[ -z "${server_cn}" && -n "${SERVER_CN_ENV}" ]]; then
	server_cn="${SERVER_CN_ENV}"
fi

if [[ -z "${server_cn}" && "${#client_cns[@]}" -eq 0 ]]; then
	echo "Nothing to generate."
	usage
	exit 1
fi

if [[ -n "${server_cn}" ]]; then
	issue_server_cert "${server_cn}"
fi

for cn in "${client_cns[@]}"; do
	issue_client_cert "${cn}"
done

echo "Done."
