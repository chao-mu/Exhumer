#!/usr/bin/env ruby

load File.join(File.dirname(__FILE__), '..', 'config', 'setup.rb')

require 'exhumer/module' 
require 'public_suffix'
require 'net/dns/resolver'
require 'pp'

if ARGV.length < 1
  warn "synopsis:      #{$0} <bing app id> [ip, ..]"
  warn "usage example: #{$0} EEB3EB8871DCCD5639E692A5A55A023957D04EC1 206.220.193.152 4.59.136.200"
  exit 2
end
app_id, ips = ARGV
ips = [ips].flatten

def bing_reverse_lookup(app_id, ip)
  bing_path = File.join(MODULE_DIR, 'search', 'bing.rb')
  bing_mod  = Exhumer::Module.load_module(bing_path)
  bing_opts = {
    :app_id => app_id, 
    :query  => "ip:#{ip}"
  }
  hosts = []

  bing_mod.each(bing_opts) do |query, uri, descr|
    hosts << uri.host
  end

  hosts.uniq
end

def lookup_records(domains, record_type)
  resolver = Net::DNS::Resolver.new  

  domains.map do |domain|
    resolver.query(domain, record_type).answer
  end.flatten
end

domains = []

# Use bing to build a list of domains
ips.each do |ip|
  bing_reverse_lookup(app_id, ip).each do |hostname|
    domains |= [hostname, PublicSuffix.parse(hostname).domain]
  end
end

# Various DNS records
records = []

# Lookup PTR records
lookup_records(ips, Net::DNS::PTR).each do |record|
  domains |= [record.ptr]
  records |= [record.to_s]
end

# Lookup common record types
%w(A AAAA CNAME MX NS SOA SRV TXT).each do |type|
  lookup_records(domains, type).each do |record|
    records |= [record.to_s]
  end
end

# Display results
records.sort.each do |record|
  puts record
end
