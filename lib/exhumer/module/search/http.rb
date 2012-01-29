require 'exhumer/module'

require 'mechanize'
require 'nokogiri'

module Exhumer::Module::Search::HTTP
  attr_accessor :http_agent

  def initialize
    mech = Mechanize.new
    mech.user_agent_alias = 'Mac Safari'

    add_retrieval_method('http', 'https') do |uri, referer|
      mech.get(uri, [], referer).body.to_s
    end

    self.http_agent = mech

    super
  end

  def normalize_body(body)
    Nokogiri::HTML(body)
  end

end
