require 'exhumer/module/search'
require 'exhumer/module/search/http'

require 'uri'
require 'cgi'

class Awesomesauce < Exhumer::Module::Search
  include Exhumer::Module::Search::HTTP

  def setup
    pref_uri  = URI('http://www.google.com/preferences?hl=en')
    pref_body = normalize_body(follow_uri(pref_uri))
    sig       = pref_body.css('[name=sig]').first['value']
    prefs = {
      :sig       => sig,
      :uulo      => 1,
      :luul      => '',
      :safeui    => 'off',
      :suggon    => 2,
      :num       => 100,
      :newwindow => 0,
      :q         => '',
      :submit2   => 'Save+Preferences'
    }

    query = prefs.map do |k, v|
      k.to_s << '=' << v.to_s
    end.join('&')

    set_pref_uri = URI('http://www.google.com/setprefs')
    set_pref_uri.query = query

    follow_uri(set_pref_uri)
  end

  def results_at(uri, body)
    results = {}

    body.css('li.g').each do |li|
      description = li.text
      link = li.css('a').first['href']

      results[URI(link)] = description
    end

    results
  end

  def next_search_uri(uri, body)
    next_link = body.css('#pnnext').first

    if next_link.nil?
      return nil
    end

    uri.merge(next_link['href'])
  end

  def search_uri(query)
    query = CGI::escape(query)

    #URI("https://encrypted.google.com/search?num=100&q=#{query}")
    URI("http://google.com/search?num=100&q=#{query}")
  end
end
