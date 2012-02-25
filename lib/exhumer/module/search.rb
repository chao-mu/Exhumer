require 'exhumer/module'

class Exhumer::Module::Search < Exhumer::Module

  def throttle(&f)
    delay

    f.call
  end

  def delay
  end

  def results_at(body)
    raise 'results_at must be overridden' 
  end

  def to_uri(seed)
    raise 'to_uri must be overridden'
  end

  def retrieve(uri)
    raise 'retrieve must be overridden'
  end

  def throttled_retrieve(uri)
    throttle do
      retrieve(uri)
    end
  end

  def advance_search(last_uri, last_page)
    raise 'advance_search must be overridden'
  end

  def each(seed, max_queries=1.0/0, &f)
    search_uri  = to_uri(seed)
    search_body = throttled_retrieve(search_uri)
    search_todo = [[search_uri, search_body]]
    searches    = 1

    until search_todo.empty? or searches >= max_queries
      search_uri, search_body = search_todo.pop

      results_at(search_body).each_pair do |uri, description|
        f.call(search_uri, uri, description)
      end

      [*advance_search(search_uri, search_body)].each do |advancement|
        if advancement.kind_of?(URI)
          search_todo.push [advancement, nil]
        elsif advancment.kind_of?(Array)
          search_todo.push advancement
        elsif !advancement.nil?
          search_todo.push [nil, advancement]
        end
      end
      searches = searches + 1
    end
  end
end
