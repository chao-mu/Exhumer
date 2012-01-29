#!/usr/bin/env ruby

load File.join(File.dirname(__FILE__), '..', 'config', 'setup.rb')

require 'mechanize'
require 'exhumer/module'

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'

if ARGV.length != 2
  warn "usage: #{$0} path/to/search/module.rb path/to/plunder/module.rb"
  exit 1
end

search_path, plunder_path = ARGV

search_mod  = Exhumer::Module.load_module(search_path)
plunder_mod = Exhumer::Module.load_module(plunder_path)

plunder_mod.google_dorks.each do |tag, queries|
  queries.each do |query|
    search_mod.each(query, 2) do |search_uri, link, description|
      loot = []

      description_loot = plunder_mod.scan(description).uniq
      loot |= description_loot

      # Attempt to skip false positives
      unless description_loot.empty?
        loot |= plunder_mod.scan(agent.get(link).body).uniq
      end

      loot.each do |lut|
        puts [search_uri, link, lut].join(' ')
      end
    end
  end
end
