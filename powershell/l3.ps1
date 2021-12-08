get-ciminstance win32_networkadapterconfiguration | where-object {$_.IPEnabled -eq "True"} |
format-table Description, Index, IpAddress, IPSubnet, DNSdomain, DNSserversearchorder