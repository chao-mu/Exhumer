require 'exhumer/module/search'
require 'exhumer/module/search/mechanize'

require 'uri'
require 'nokogiri'
require 'cgi'

class Awesomesauce < Exhumer::Module::Search
  include Exhumer::Module::Search::Mechanize

  def setup
  end

  def results_at(page)
    results = {}
 
    Nokogiri::HTML(page.body).traverse do |el|
      [el[:src], el[:href], el[:action]].each do |uri|
        next if uri.nil?
      
        uri = URI(uri)
        unless uri.absolute?
          uri = page.uri.merge(uri)
        end
        
        results[uri.to_s] = el
      end
    end

    results
  end

  def to_uri(uri)
    URI(uri.to_s)
  end

  def next_page(last_uri, last_page)
    nil
  end
end
