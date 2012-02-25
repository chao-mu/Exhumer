#!/usr/bin/env ruby

load File.join(File.dirname(__FILE__), '..', 'config', 'setup.rb')

require 'exhumer/module'

if ARGV.length < 1
  warn "synopsis:      #{$0} <bing id> [ip, ..]"
  warn "usage example: #{$0} EEB3EB8871DCCD5639E692A5A55A023957D04EC1 206.220.193.152 4.59.136.200"
  exit 2
end
app_id, ips = ARGV
ips = [ips].flatten

def domain_lookup(app_id, ips, &f)
  ips.each do |ip|
    bing_domain_lookup(app_id, ip, &f)
  end
end

def bing_domain_lookup(app_id, ip, &f)
  bing_path = File.join(MODULE_DIR, 'search', 'bing.rb')
  bing_mod  = Exhumer::Module.load_module(bing_path)
  bing_opts = {
    :app_id => app_id, 
    :query  => "ip:#{ip}"
  }
  
  bing_mod.each(bing_opts) do |query, uri, descr|
    f.call(uri.host)
  end
end

host_history = {}
domain_lookup(app_id, ips) do |host|
  unless host_history[host]
    puts host
    host_history[host] = true 
  end
end
