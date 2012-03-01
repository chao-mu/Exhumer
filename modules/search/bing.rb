require 'exhumer/module/search'
require 'exhumer/module/search/net_http'
require 'addressable/uri' 
require 'json'

class Awesomesauce < Exhumer::Module::Search
  include Exhumer::Module::Search::NetHTTP

  DEFAULT_RESULT_COUNT = 10

  def parse_bing_response(page)
    JSON(page)['SearchResponse']['Web']
  end

  def results_at(page)
    results = {}

    parse_bing_response(page)['Results'].each do |result|
      results[URI(result['Url'])] = result['Description']
    end

    results
  end

  def advance_search(last_uri, last_page)
    last_response = parse_bing_response(last_page)
    last_query    = last_uri.query_values

    web_count   = last_query.fetch('Web.Count', DEFAULT_RESULT_COUNT).to_i

    last_offset = last_response['Offset'].to_i
    next_offset = web_count + last_offset

    if next_offset > last_response['Total']
      return []
    end

    next_uri = last_uri.dup
    next_uri.query_values = last_query.merge('Web.Offset' => next_offset)

    next_uri
  end

  def to_uri(opts)
    uri = Addressable::URI.parse('http://api.bing.net/json.aspx')

    uri.query_values = {
      'Adult'     => 'Off',
      'AppId'     => opts[:app_id],
      'Version'   => '2.2',
      'Sources'   => 'web',
      'Web.Count' => 50,
      'Query'     => opts[:query],
    }

    uri
  end
end
