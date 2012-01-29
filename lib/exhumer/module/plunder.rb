require 'exhumer/module'

class Exhumer::Module::Plunder < Exhumer::Module

  attr_reader :patterns

  def add_pattern(tag, regex) 
    if @patterns.nil?
      @patterns = []
    end

    patterns.push({
      :tag   => tag,
      :regex => regex
    })
  end

  def scan(input)
    loot = []

    patterns.each do |pattern|
      regex = pattern[:regex]

      input.scan(regex) do |value|
        #loot.push({
        #  :tag   => pattern[:tag],
        #  :regex => regex
        #})
	loot.push value

#
#        matchdata.names.each do |tag|
#          value = $~[type]
#
#          loot.push {
#            :tag         => tag,
#            :value       => matchdata[tag],
#            :context     => input,
#            :regex       => regex
#          }
#        end
      end
    end

    loot
  end

  def simple_scan(input)
    scan(input).map do |loot|
      loot.value
    end
  end
end
