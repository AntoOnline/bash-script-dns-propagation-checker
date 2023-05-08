#!/bin/bash

# Remove DNS servers from the list if name servers could not be reached or record not found.
# Only used to trim old or stale DNS servers from the list. Use example.com to test.
remove_dns_server="n"

query_dns_servers() {
    local domain="$1"
    local record_type="$2"
    local dns_servers_yaml="$3"
    local remove_dns_server="$4"

    counter=0
    total_dns_servers=$(yq -r 'length' "$dns_servers_yaml")

    while read -r dns_server; do
        counter=$((counter+1))
        remaining_dns_servers=$((total_dns_servers-counter))

        dns_server_ip=$(yq -r ".[] | select(.reverse == \"$dns_server\").ip" "$dns_servers_yaml")
        dns_server_reverse=$(yq -r ".[] | select(.reverse == \"$dns_server\").reverse" "$dns_servers_yaml")
        dns_server_provider=$(yq -r ".[] | select(.reverse == \"$dns_server\").provider" "$dns_servers_yaml")
        dns_server_country=$(yq -r ".[] | select(.reverse == \"$dns_server\").country" "$dns_servers_yaml")

        echo "Querying DNS server: ${dns_server_reverse} (${dns_server_ip}) (${counter}/${total_dns_servers})"
        if [[ -n "$dns_server_provider" ]]; then
            echo "Provider: ${dns_server_provider}"
        fi
        if [[ -n "$dns_server_country" ]]; then
            echo "Country: ${dns_server_country}"
        fi
        if [[ -n "$dns_server_reverse" ]]; then
            echo "Reverse DNS: ${dns_server_reverse}"
        fi

        # Dig the domain for the record type and if "no servers could be reached" then echo "no servers could be reached"
        records=$(dig "@${dns_server_ip}" "${record_type}" "${domain}" +short)
        if [ -z "$records" ]; then
            echo "No ${record_type} records found for ${domain}"
        elif [[ "$records" =~ "no servers could be reached" ]]; then
            echo "No servers could be reached"
            if [[ $remove_dns = "y" ]]; then
                yq "del(.[] | select(.reverse == \"$dns_server_reverse\"))" "$dns_servers_yaml" -i
            fi
        else
            echo "${record_type} records for ${domain}:"
            echo "${records}"
        fi

        echo ""
    done < <(yq -r '.[].reverse' "$dns_servers_yaml")
}

if [ -z "$1" ]; then
    echo "Usage: $0 <domain> [record_type] [dns_yaml_file]"
    exit 1
fi

# Validate the domain name
domain_pattern="^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$"
if [[ ! "${1}" =~ $domain_pattern ]]; then
    echo "Invalid domain name: ${1}"
    exit 1
fi
domain="${1}"

record_type="${2}"

# Validate the record type
if [[ ! "$record_type" =~ ^(A|AAAA|CNAME|MX|NS|PTR|SOA|SRV|TXT)$ ]]; then
    echo "Invalid record type: can be A, AAAA, CNAME, MX, NS, PTR, SOA, SRV or TXT"
    exit 1
fi

# Validate list type
dns_yaml_file="${3}"

# Load the DNS servers list from YAML file
if [ ! -f "$dns_yaml_file" ]; then
    echo "Error: $dns_yaml_file not found"
    exit 0
fi

# Check if yq is installed and install it if it's not
if ! command -v yq &> /dev/null; then
    echo "yq not found, please install..."
    # sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && sudo chmod +x /usr/bin/yq
    exit 1
fi

# Original list from: https://github.com/YoSmudge/dnsyo/blob/master/resolver-list.yml

# Query each DNS server for: common servers
printf "Getting ${record_type} records for ${domain} from ${total_servers} ${dns_yaml_file} DNS servers...\n\n"
query_dns_servers $1 $2 $dns_yaml_file $remove_dns_server
