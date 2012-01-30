#!/usr/bin/env ruby

load File.join(File.dirname(__FILE__), '..', 'config', 'setup.rb')

require 'mechanize'
require 'exhumer/module'

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'

if ARGV.length != 2
  warn "usage:   #{$0} path/to/plunder/module.rb path/to/search/module.rb"
  warn "example: #{$0} modules/plunder/crypt.rb  modules/search/google.rb"
  exit 1
end

plunder_path, search_path  = ARGV

plunder_mod = Exhumer::Module.load_module(plunder_path)
search_mod  = Exhumer::Module.load_module(search_path)

plunder_mod.dorks.each do |tag, queries|
  queries.each do |query|
    search_mod.each(query, 2) do |search_uri, link, description|
      loot = []

      description_loot = plunder_mod.scan(description).uniq
      loot |= description_loot

      # Attempt to skip false positives
      unless description_loot.empty?
        begin
          body = agent.get(link).body
          loot |= plunder_mod.scan(body).uniq
        rescue Net::HTTPClientError, Mechanize::Error, Timeout::Error, OpenSSL::SSL::SSLError, Net::HTTP::Persistent::Error, SocketError, Errno::ETIMEDOUT => e
          warn "Error (#{link.to_s}): " << e.to_s
        end
      end

      loot.each do |lut|
        puts [search_uri, link, lut].join(' ')
      end
    end
  end
end
