require "json"
require "resolv"
require "ipaddr"

cwd = File.dirname(__FILE__)
Dir.chdir(cwd)
load "util.rb"

###

ca = File.read("../static/ca.pem")
tls_wrap = read_tls_wrap("auth", 1, "../static/ta.key", 4)
countries = ["US", "FR", "DE", "ES", "IT"]
bogus_ip_prefix = "1.2.3"

cfg = {
  ca: ca,
  tlsWrap: tls_wrap,
  cipher: "AES-128-GCM",
  digest: "SHA1",
  compressionFraming: 1,
  keepAliveInterval: 60,
  renegotiatesAfterSeconds: 3600
}

recommended = {
  id: "default",
  name: "Default",
  comment: "128-bit encryption",
  ovpn: {
    cfg: cfg,
    endpoints: [
      "UDP:1194",
      "TCP:443",
    ],
  }
}
presets = [recommended]

defaults = {
  :username => "myusername",
  :pool => "us",
  :preset => "default"
}

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

###

infra = {
  :pools => pools,
  :presets => presets,
  :defaults => defaults
}

puts infra.to_json
puts
