require 'exhumer/module'

require 'addressable/uri'

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
    end end

  def advance_search(last_uri, last_page)
    []
  end

  def each(seed, max_queries=1.0/0, &f)
    search_uri  = to_uri(seed)
    search_body = throttled_retrieve(search_uri)
    search_todo = [[search_uri, search_body]]
    searches    = 1

    until search_todo.empty? or searches >= max_queries
      search_uri, search_body = search_todo.pop

      if search_body.nil?
        search_body = throttled_retrieve(search_uri)
      end

      if search_body.nil?
        next
      end

      results_at(search_body).each_pair do |uri, description|
        f.call(search_uri, uri, description)
      end

      search_todo |= normalize_advancements(
          advance_search(search_uri, search_body))

      searches = searches + 1
    end
  end

private
  # Such a pain in the ass
  def normalize_advancements(xs)
    if xs.kind_of?(Array)
      if xs.count == 1 and xs.first.kind_of?(Array)
        xs = xs.first
      end
    else
      xs = [xs] 
    end
    
    # create an array of advancements ([uri, page])
    xs.map do |x|
      if x.kind_of?(URI) or x.kind_of?(Addressable::URI)
        # It's just the next URI
        [x, nil]
      elsif x.kind_of?(Array) and x.count == 2
        # It's already a uri&page pair
        x
      elsif !x.nil?
        # It's just the page
        [nil, x]
      end
    end
  end
end
