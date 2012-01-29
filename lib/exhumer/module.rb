require 'exhumer'

class Exhumer::Module
	def self.load_module(mod_path)
		wrapper = ::Module.new
		wrapper.module_eval(File.read(mod_path))
		mod_klass = wrapper.const_get wrapper.constants.first {|c| c.kind_of? Class}

		mod = mod_klass.new

		mod
	end
end
