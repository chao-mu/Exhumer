require 'exhumer/module'

class Exhumer::Module::Search < Exhumer::Module

  def results_at(uri, body)
    raise 'results_at must be overridden' 
  end

  def next_search_uri(uri, body)
    raise 'next_search_uri must be overridden'
  end

  def search_uri(seed)
    raise 'search_uri must be overridden'
  end

  def initialize
    super
    setup
  end

  def setup
  end

  def add_retrieval_method(*schemes, &f)
    schemes.each do |scheme|
      if retrieval_methods.has_key? scheme
        warn "WARNING: add_retrieval_method overriding scheme #{scheme}"
      end

      retrieval_methods[scheme] = f
    end
  end

  def retrieval_methods
    if @retrieval_methods.nil?
      @retrieval_methods = {}
    end

     @retrieval_methods
  end

  def follow_uri(uri, referer=nil)
    scheme = uri.scheme

    unless retrieval_methods.has_key? scheme
      raise "Schema #{scheme} is not supported"
    end

    retrieval_methods[scheme].call(uri, referer)
  end

  def each(seed, max_queries=1.0/0, &f)
    search_uri = search_uri(seed) 
    searches   = 0
    referer    = nil

    until search_uri.nil? or searches >= max_queries
      search_body = normalize_body(follow_uri(search_uri, referer))

      results_at(search_uri, search_body).each_pair do |uri, description|
        f.call(search_uri, uri, description)
      end

      referer    = search_uri
      search_uri = next_search_uri(search_uri, search_body)
      searches   = searches + 1
    end
  end
end
