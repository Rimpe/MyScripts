source: https://www.reddit.com/r/PFSENSE/comments/89gt37/stuck_on_starting_dns_resolver_on_reboot/

```
this worked for me: hit ctrl-c + enter > to bring you to the shell #
backup the file just in case

cp /var/unbound/pfb_dnsbl.conf /tmp
Delete it

rm /var/unbound/pfb_dnsbl.conf
re-create an empty file

touch /var/unbound/pfb_dnsbl.conf

reboot
```
