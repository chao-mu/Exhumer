require 'exhumer/module/search'
require 'exhumer/module/search/net_http'

require 'json'

class Awesomesauce < Exhumer::Module::Search
  include Exhumer::Module::Search::NetHTTP

  def results_at(page)
    response = JSON(page)['SearchResponse']
    results  = {}

    response.fetch('Web', {}).fetch('Results', []).each do |result|
      results[URI(result['Url'])] = result['Description']
    end

    results
  end

  def advance_search(last_uri, last_page)
    []
  end

  def to_uri(opts)
    URI("http://api.bing.net/json.aspx?AppId=#{opts[:app_id]}&Version=2.2&Market=en-US&Query=#{opts[:query]}&Sources=web&Web.Count=50")
  end
end
