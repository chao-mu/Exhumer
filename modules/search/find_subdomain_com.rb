require 'exhumer/module/search'
require 'exhumer/module/search/mechanize'

require 'net/http'
require 'public_suffix'
require 'json'
require 'cgi'

class Awesomesauce < Exhumer::Module::Search
  include Exhumer::Module::Search::Mechanize

  def results_at(page)
    results = {}

    JSON(page.body).fetch('found', []).each do |subdomain|
      # Sometimes findsubdomain.com leaves port numbers in 
      subdomain.sub!(/:\d+$/, '')
      results[subdomain] = PublicSuffix.parse(subdomain).domain
    end

    results
  end
  
  def retrieve(uri)
    domain = CGI.parse(uri.query)['q'].first

    mech.post(uri, {'q' => domain})
  end

  def to_uri(opts)
    # This will need to be a post with the query string as its data
    URI('http://findsubdomain.com/search.php?q=' << opts[:domain])
  end
end
