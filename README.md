# chkdomain

Check if a domain can be resolved or been blocked by no-filter DNS, secure/protective DNS, and AD/Tracker-blocking DNS services. Then provide the links to [OSINT](https://en.wikipedia.org/wiki/Open-source_intelligence), domain threat intelligence, and security services about this domain.

Currently, these are the DNS services we used to send the queries to.

| **No-filter** DNS                              | **Secure** DNS                                   | **AD/Tracker-blocking** DNS                 |
| ---------------------------------------------- | ------------------------------------------------ | ------------------------------------------- |
| [AdGuard][AdGuard] (`94.140.14.140`)           | [CleanBrowsing][CleanBrowsing] (`185.228.168.9`) | [AdGuard][AdGuard] (`94.140.14.14`)         |
| [Cloudflare][Cloudflare] (`1.1.1.1`)           | [Cloudflare][Cloudflare] (`1.1.1.2`)             | [AhaDNS][AhaDNS] (`5.2.75.75`)              |
| [dns0.eu][dns0.eu] (`193.110.81.254`)          | [Comodo][Comodo] (`8.26.56.26`)                  | [CONTROL D][CONTROL D] (`76.76.2.2`)        |
| [Freenom World][Freenom World] (`80.80.80.80`) | [CONTROL D][CONTROL D] (`76.76.2.1`)             | [dnsforge.de][dnsforge.de] (`176.9.93.198`) |
| [Google][Google] (`8.8.8.8`)                   | [dns0.eu][dns0.eu] (`193.110.81.0`)              | [OVPN][OVPN] (`192.165.9.157`)              |
| [Hinet][Hinet] (`168.95.1.1`)                  | [UltraDNS][UltraDNS] (`156.154.70.2`)            | [Tiarap][Tiarap] (`188.166.206.224`)        |
| [UltraDNS][UltraDNS] (`64.6.64.6`)             | [OpenDNS][OpenDNS] (`208.67.222.222`)            |                                             |
| [OpenDNS][OpenDNS] (`208.67.222.2`)            | [Quad101][Quad101] (`101.101.101.101`)           |                                             |
| [Quad9][Quad9] (`9.9.9.10`)                    | [Quad9][Quad9] (`9.9.9.9`)                       |                                             |
| [Yandex][Yandex] (`77.88.8.1`)                 | [SafeDNS][SafeDNS] (`195.46.39.39`)              |                                             |
|                                                | [Yandex][Yandex] (`77.88.8.2`)                   |                                             |

And these are the intelligence services that will be listed with directly link to the domain been checked:

- [AlienVault Open Threat Exchange](https://otx.alienvault.com/)
- [Bitdefender TrafficLight](https://trafficlight.bitdefender.com/info/)
- [Google Safe Browsing](https://transparencyreport.google.com/safe-browsing/search)
- [Kaspersky Threat Intelligence Portal](https://opentip.kaspersky.com/?tab=lookup)
- [McAfee SiteAdvisor](https://siteadvisor.com/)
- [Norton Safe Web](https://safeweb.norton.com/)
- [OpenDNS](https://domain.opendns.com/)
- [URLVoid](https://www.urlvoid.com/scan/)
- [VirusTotal](https://www.virustotal.com/gui/home/url)
- [Yandex Site safety report](https://yandex.com/safety/)

If you're like to build up your own secure DNS, here's a list of threat hosts intelligence: [threat-hostlist](https://github.com/PeterDaveHello/threat-hostlist), you can setup a DNS blocker with those blocklists to run your own secure DNS service, in your home, your office, or anywhere.

## Usage

Download [`chkdm`](https://github.com/PeterDaveHello/chkdomain/raw/master/chkdm) script into your working directory, give it executable permission:

```sh
$ wget https://github.com/PeterDaveHello/chkdomain/raw/master/chkdm
$ chmod +x chkdm
```

Now you can check the domain with command `chkdm`:

```sh
$ ./chkdm <domain name>
```

You can also put the script in your `$PATH`, for example: `/usr/local/bin`, so that you can execute it everywhere.

## Screenshot

![Screenshot](chkdomain.png)

## Demo

[![asciicast](https://asciinema.org/a/474151.svg)](https://asciinema.org/a/474151)

## Dependency

Only a few command-line tools are needed:

- awk
- bash
- dig
- head
- nslookup
- sed
- sort

## Notice

Domain name with records like `0.0.0.0` or `127.0.0.1`, like `0.ipinfo.tw` or `1.ipinfo.tw` would have a wrong check result with secure DNS and AD-blocking DNS services, because the current detection about blocked domain is pretty simple. This feature will be improved in the future.

## Additional Resources

There're also some malicous domains blocking services, but they didn't directly provide DNS serivces, can't be quried via HTTP GET method, so we aren't able to integrate, or list corresponding query URL in the check results, however, they are provided by leading security companies, which makes them worthy to be mentioned, and they do provide a web interface that you can manually to submit a domain to retrive the intelligence. Those services are listed as below:

- FortiGuard Web Filter Lookup
  - <https://www.fortiguard.com/webfilter>
- Trend Micro Site Safety Center
  - <https://global.sitesafety.trendmicro.com>
- Palo Alto Networks URL filtering
  - <https://urlfiltering.paloaltonetworks.com/>

## License

GPL-3.0 (GNU GENERAL PUBLIC LICENSE Version 3)

[AdGuard]: https://adguard-dns.com/
[AhaDNS]: https://ahadns.com/
[CleanBrowsing]: https://cleanbrowsing.org/
[Cloudflare]: https://1.1.1.1/family/
[Comodo]: https://www.comodo.com/secure-dns/
[CONTROL D]: https://controld.com/
[dns0.eu]: https://www.dns0.eu/
[dnsforge.de]: https://dnsforge.de/
[Freenom World]: https://www.freenom.world/
[Google]: https://developers.google.com/speed/public-dns/
[Hinet]: https://dns.hinet.net/
[UltraDNS]: https://www.publicdns.neustar/
[OpenDNS]: https://www.opendns.com/
[Quad101]: https://101.101.101.101/
[Quad9]: https://quad9.net/
[SafeDNS]: https://www.safedns.com/
[OVPN]: https://www.ovpn.com/en/faq/functionality/adblock-dns
[Tiarap]: https://tiarap.org/
[Yandex]: https://dns.yandex.com/
