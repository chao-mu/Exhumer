require 'exhumer/module'

require 'net/http'

module Exhumer::Module::Search::NetHTTP
  def retrieve(uri)
    Net::HTTP.get(uri)
  end
end
