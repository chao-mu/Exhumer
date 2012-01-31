require 'exhumer/module'

class Exhumer::Module::Bot
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

end
