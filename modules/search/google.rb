require 'exhumer/module/search'
require 'exhumer/module/search/mechanize'

require 'uri'
require 'nokogiri'
require 'cgi'

class Awesomesauce < Exhumer::Module::Search
  include Exhumer::Module::Search::Mechanize

  def setup
    pref_uri  = URI('http://www.google.com/preferences?hl=en')
    pref_form = retrieve(pref_uri).form_with(:id => 'ssform')

    pref_form.set_fields(:num => 100, :suggon => 2, :safeui => 'off')

    delay

    pref_form.submit
  end

  def delay
    sleep(rand * 10) 
  end

  def results_at(page)
    results = {}

    Nokogiri::HTML(page.body).css('li.g').each do |li|
      description = li.text
      link = li.css('a').first['href']

      results[URI(link)] = description
    end

    results
  end

  def advance_search(last_uri, last_page)
    next_link = last_page.link_with(:id => 'pnnext')

    if next_link.nil?
      return nil
    end

    [next_link.uri, next_link.click]
  end

  def to_uri(query)
    query = CGI::escape(query)

    #URI("https://encrypted.google.com/search?num=100&q=#{query}")
    URI("http://google.com/search?num=100&q=#{query}")
  end
end
