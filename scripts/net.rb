require "json"
require "resolv"
require "ipaddr"

cwd = File.dirname(__FILE__)
Dir.chdir(cwd)

ca = File.read("../certs/ca.pem")
countries = ["US", "FR", "DE", "ES", "IT"]
bogus_ip_prefix = "1.2.3"

###

pools = []
countries.each { |k|
    id = k.downcase
    hostname = "#{id}.sample-vpn-provider.bogus"

    addresses = nil
    if ARGV.length > 0 && ARGV[0] == "noresolv"
        addresses = []
    else
        #addresses = Resolv.getaddresses(hostname)
        addresses = []
        octet = 1
        5.times {
            ip = "#{bogus_ip_prefix}.#{octet}"
            addresses << ip
            octet += 1
        }
    end
    addresses.map! { |a|
        IPAddr.new(a).to_i
    }

    pool = {
        :id => id,
        :name => "Sample #{k}",
        :country => k,
        :hostname => hostname,
        :addrs => addresses
    }
    pools << pool
}

recommended = {
    id: "recommended",
    name: "Recommended",
    comment: "128-bit encryption",
    cfg: {
        ep: [
            "UDP:1194",
            "TCP:443",
        ],
        cipher: "AES-128-GCM",
        auth: "SHA1",
        ca: ca,
        frame: 1,
        ping: 60,
        reneg: 3600
    }
}
presets = [recommended]

defaults = {
    :username => "myusername",
    :pool => "us",
    :preset => "recommended"
}

###

infra = {
    :pools => pools,
    :presets => presets,
    :defaults => defaults
}

puts infra.to_json
puts
