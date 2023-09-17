Your "scraping" logic should go here. Find functional examples in any of the `api-source-*` repositories under the "scripts" folder.

The output JSON must follow this format:

```
{
    "locations": [...],             // list of locations
    "presets": [...],               // list of presets
    "defaults": {...}               // map of default values
}
```

Types with a trailing ? are optional.

Location:

```
{
    "category": String?             // the location category (default category if null)
    "id": String,                   // unique location identifier across infrastructure
    "country": String,              // country code (uppercase)
    "extra_countries": [String]?,   // additional country codes if applicable (uppercase)
    "area": String?,                // geographic area
    "num": Int?,                    // server numeric index
    "hostname": String?,            // server hostname
    "addrs": [Int]?                 // pre-resolved IPv4 addresses (32-bit)
}
```

Preset:

```
{
    "id": String,                   // unique preset identifier
    "name": String,                 // English name for the preset
    "comment": String,              // short description
    "ovpn": [String: Any],          // an object representing an OpenVPN configuration
    "wg": [String: Any]             // an object representing a WireGuard configuration
}
```

with the structure for [OpenVPN][doc-ovpn] and [WireGuard][doc-wg] configurations.

Defaults:

```
{
    "username": String,             // placeholder for account username
    "country": String               // default location country code (uppercase)
}
```

[doc-ovpn]: https://github.com/passepartoutvpn/tunnelkit/blob/master/Sources/TunnelKitOpenVPNCore/Configuration.swift#L356
[doc-wg]: https://github.com/passepartoutvpn/tunnelkit/blob/master/Sources/TunnelKitWireGuardCore/Configuration.swift#L30
