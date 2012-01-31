require 'exhumer/module'

require 'mechanize'
require 'nokogiri'

module Exhumer::Module::Search::Mechanize
  attr_accessor :mech

  def initialize
    self.mech = Mechanize.new
    mech.user_agent_alias = 'Mac Safari'

    super
  end

  def retrieve(uri)
    mech.get(uri)
  end
end
