require 'exhumer/module'

class Exhumer::Module::Search < Exhumer::Module

  def results_at(body)
    raise 'results_at must be overridden' 
  end

  def to_uri(seed)
    raise 'to_uri must be overridden'
  end

  def retrieve(uri)
    raise 'retrieve must be overridden'
  end

  def next_page(last_uri, last_page)
    raise 'next_page must be overridden'
  end

  def each(seed, max_queries=1.0/0, &f)
    search_uri  = to_uri(seed)
    search_body = retrieve(search_uri)
    searches    = 0

    until search_body.nil? or searches >= max_queries
      searches = searches + 1

      results_at(search_body).each_pair do |uri, description|
        f.call(search_uri, uri, description)
      end

      search_uri, search_body = next_page(search_uri, search_body)
      if search_body.nil?
         search_body = retrieve(search_uri)
      end
    end
  end
end
