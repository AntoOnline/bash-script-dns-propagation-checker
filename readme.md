# DNS Query Script README

This is a bash script that allows you to query a domain name for various DNS record types (A, AAAA, CNAME, MX, NS, PTR, SOA, SRV, TXT) using a list of popular DNS servers. The script loads the list of DNS servers from YAML files and uses `dig` to perform the queries.

## Usage

The script can be run from the command line using the following syntax:

```bash
./dns_query.sh <domain> [record_type]
```

Where `<domain>` is the domain name to query and `[record_type]` is the type of DNS record to query (default is A record).

## Dependencies

The script requires `dig` and `yq` to be installed. You can install `yq` by downloading the latest release from the [GitHub page](https://github.com/mikefarah/yq/releases) and adding the binary to your PATH.

## DNS Server Lists

The script uses two YAML files to load the list of DNS servers: `dns_servers_common.yaml` and `dns_servers_all.yaml`. The `dns_servers_common.yaml` file contains a list of popular DNS servers, while the `dns_servers_all.yaml` file contains a larger list of DNS servers.

You can add or remove DNS servers from the YAML files as needed.

## Removing Stale DNS Servers

By default, the script does not remove DNS servers from the list. However, you can enable this feature by setting the `remove_dns_server` variable to `true` in the script.

## Output

The script outputs the DNS server being queried, along with its reverse DNS, IP address, provider, and country (if available). For each DNS server, the script outputs the results of the DNS query, or an error message if the query failed.

## Example Usage

```bash
./dns_query.sh example.com MX
```

This command will query example.com for MX records using the default list of DNS servers. The results will be displayed in the terminal.

## Want to connect?

Feel free to contact me on [Twitter](https://twitter.com/OnlineAnto), [DEV Community](https://dev.to/antoonline/) or [LinkedIn](https://www.linkedin.com/in/anto-online) if you have any questions or suggestions.

Or just visit my [website](https://anto.online) to see what I do.
