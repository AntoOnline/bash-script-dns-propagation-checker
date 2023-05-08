# DNS Query Script

This script performs DNS queries for a specified domain and record type against a list of DNS servers provided in a YAML file. It uses the `dig` command to query each DNS server in the list, and returns the results of the query.

## Usage

```bash
./dns_query.sh <domain> [record_type] <dns_yaml_file>
```

- `domain` - The domain name to query.
- `record_type` - Optional. The type of DNS record to query for. Must be one of `A`, `AAAA`, `CNAME`, `MX`, `NS`, `PTR`, `SOA`, `SRV`, or `TXT`. If not specified, the script will default to querying for `A` records.
- `dns_yaml_file` - Required. The YAML file containing the list of DNS servers to query.

## Removing DNS servers

The script allows you to remove stale DNS servers from the list. To enable this feature, set the `remove_dns_server` variable to `y` in the script before running it.

```bash
remove_dns_server="n"
```

If a DNS server in the list cannot be reached or returns an error for the specified domain and record type, the script will automatically remove it from the list if `remove_dns_server` is set to `y`.

## YAML file format

The list of DNS servers to query should be provided in a YAML file with the following format:

```yaml
- reverse: <reverse DNS>
  ip: <IP address>
  provider: <provider name>
  country: <country code>
```

- `reverse` - The reverse DNS name for the DNS server.
- `ip` - The IP address of the DNS server.
- `provider` - The name of the DNS server provider.
- `country` - The two-letter country code of the location of the DNS server.

The script comes with two sample YAML files:

- `dns_servers_all.yaml` - Contains a list of DNS servers from various providers and countries.
- `dns_servers_common.yaml` - Contains a list of commonly used DNS servers.

You can use one of these files as a starting point for your own list of DNS servers.

## Dependencies

This script requires the `dig` command and the `yq` tool. If `yq` is not installed, the script will prompt the user to install it.
