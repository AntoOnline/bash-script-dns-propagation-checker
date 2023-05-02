#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <domain> [record_type]"
    exit 1
fi

# Validate the domain name
domain_pattern="^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$"
if [[ ! "${1}" =~ $domain_pattern ]]; then
    echo "Invalid domain name: ${1}"
    exit 1
fi
domain="${1}"

record_type="${2:-A}" # Default to 'A' record if not specified

# Validate the record type
if [[ ! "$record_type" =~ ^(A|AAAA|CNAME|MX|NS|PTR|SOA|SRV|TXT)$ ]]; then
    echo "Invalid record type: $record_type"
    exit 1
fi

# List of global recursive DNS servers with labels (you can modify or extend this list as needed)
declare -A recursive_dns_servers=(
  # Global
  ["Google Public DNS 1"]="8.8.8.8"
  ["Google Public DNS 2"]="8.8.4.4"
  ["Cloudflare DNS 1"]="1.1.1.1"
  ["Cloudflare DNS 2"]="1.0.0.1"
  ["Quad9 DNS 1"]="9.9.9.9"
  ["Quad9 DNS 2"]="149.112.112.112"
  ["OpenDNS 1"]="208.67.222.222"
  ["OpenDNS 2"]="208.67.220.220"
  # United States
  ["Level3 US 1"]="209.244.0.3"
  ["Level3 US 2"]="209.244.0.4"
  ["Comodo Secure US 1"]="8.26.56.26"
  ["Comodo Secure US 2"]="8.20.247.20"
  # United Kingdom
  ["OpenNIC UK 1"]="5.132.191.104"
  ["OpenNIC UK 2"]="5.132.191.162"
  ["Yandex UK 1"]="77.88.8.8"
  ["Yandex UK 2"]="77.88.8.1"
  # Europe
  ["OpenNIC DE 1"]="185.121.177.177"
  ["OpenNIC DE 2"]="169.239.202.202"
  ["OpenNIC CH 1"]="193.183.98.154"
  ["OpenNIC CH 2"]="94.103.153.176"
  # Australia
  ["OpenNIC AU 1"]="103.236.162.119"
  ["OpenNIC AU 2"]="103.236.162.118"
  ["Telstra AU 1"]="139.130.4.4"
  ["Telstra AU 2"]="61.9.211.1"
  # New Zealand
  ["ICONZ NZ 1"]="210.55.111.1"
  ["ICONZ NZ 2"]="202.27.184.3"
  ["Spark NZ 1"]="122.56.237.1"
  ["Spark NZ 2"]="210.55.111.1"
  # South Africa
  ["Vox Telecom ZA 1"]="196.35.152.253"
  ["Vox Telecom ZA 2"]="206.223.136.195"
  ["Xneelo ZA 1"]="196.22.227.25"
  ["Xneelo ZA 2"]="41.204.202.1"
  # Nigeria
  ["Spectranet NG 1"]="154.118.230.89"
  ["Spectranet NG 2"]="197.210.252.39"
  ["Swift Networks NG 1"]="41.223.93.42"
  ["Swift Networks NG 2"]="41.223.93.41"
)

# Get the TLD and authoritative name servers for the domain
tld_ns=$(dig +short SOA "$domain" | awk '{print $1}')
auth_ns=$(dig +short NS "$domain")

# Combine all the DNS servers into one list
dns_servers=("Root Name Server (A Root)" "198.41.0.4" ${!recursive_dns_servers[@]} $tld_ns $auth_ns)

echo "Getting ${record_type} records for ${domain} from global and regional DNS servers..."

# Query each DNS server for: recursive_dns_servers
for dns_server_label in "${!recursive_dns_servers[@]}"; do
    dns_server="${recursive_dns_servers[$dns_server_label]}"
    echo "Querying DNS server: ${dns_server_label} (${dns_server})"

    if [[ "$dns_server_label" =~ ^(Root|Google|OpenDNS|Cloudflare|Quad9) ]]; then
        echo "(Global DNS server)"
    else
        echo "(Regional DNS server)"
    fi

    # Dig the domain for the record type and if "no servers could be reached" then echo "no servers could be reached"
    records=$(dig "@${dns_server}" "${record_type}" "${domain}" +short)
    if [ -z "$records" ]; then
        echo "No ${record_type} records found for ${domain}"
    elif [[ "$records" =~ "no servers could be reached" ]]; then
        echo "No servers could be reached"
    else
        echo "${record_type} records for ${domain}:"
        echo "${records}"
    fi

    echo ""
done
