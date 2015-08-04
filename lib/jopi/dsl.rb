module Jopi
	module DSL

		def links array
			add_to_tree :links, array
		end


		def type name=nil
			add_to_tree :type, name || self.name 
		end

		def id
			add_to_tree :id, :id
		end

		def attributes list
			add_to_tree :attributes, list
		end

		def block name
			self.branch << name
			yield
			self.branch.pop!
		end


		
	end
end