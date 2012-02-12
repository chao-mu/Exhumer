#!/usr/bin/env ruby 

load File.join(File.dirname(__FILE__), '..', 'config', 'setup.rb')

require 'exhumer/module'


search_path = File.join(MODULE_DIR, 'search', 'generic.rb')
search_mod  = Exhumer::Module.load_module(search_path)

target = ARGV.first

search_mod.each(target) do |origin, url, element|
   puts url 
end
