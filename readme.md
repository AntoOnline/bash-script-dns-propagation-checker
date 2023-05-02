# DNS Record Type Checker

This is a bash script to check DNS records of a domain from various global and regional DNS servers. It can check for different record types such as `A`, `AAAA`, `CNAME`, `MX`, `NS`, `PTR`, `SOA`, `SRV`, and `TXT`.

## Usage

```bash
./dns_record_checker.sh <domain> [record_type]
```

- `domain`: Required. The domain name to check.
- `record_type`: Optional. The type of DNS record to check. Defaults to `A` if not specified. Must be one of `A`, `AAAA`, `CNAME`, `MX`, `NS`, `PTR`, `SOA`, `SRV`, or `TXT`.

## Requirements

This script requires the `dig` command to be installed on the system.

## Validating the Domain Name

The script validates the input domain name to ensure it conforms to the standard domain name format. This is to prevent any potential attacks from hackers.

## List of DNS Servers

The script has a list of global and regional DNS servers to query. The list can be modified or extended as needed. The global DNS servers include:

- Google Public DNS 1
- Google Public DNS 2
- Cloudflare DNS 1
- Cloudflare DNS 2
- Quad9 DNS 1
- Quad9 DNS 2
- OpenDNS 1
- OpenDNS 2

Regional DNS servers are listed for the United States, United Kingdom, Europe, Australia, New Zealand, South Africa, and Nigeria.

## Output

The script outputs the DNS records for the specified domain and record type from each DNS server queried. It also indicates if the DNS server is global or regional. If no records are found or no servers could be reached, it will print a message accordingly.

## Example Usage

```bash
./dns_record_checker.sh example.com
```

This will check the `A` records for `example.com` from all the global and regional DNS servers.

```bash
./dns_record_checker.sh example.com MX
```

This will check the `MX` records for `example.com` from all the global and regional DNS servers.


## Want to connect?

Feel free to contact me on [Twitter](https://twitter.com/OnlineAnto), [DEV Community](https://dev.to/antoonline/) or [LinkedIn](https://www.linkedin.com/in/anto-online) if you have any questions or suggestions.

Or just visit my [website](https://anto.online) to see what I do.
