
module Jopi
	class Base
		extend DSL
		class << self
			def define &script
				self.new.instance_eval(&script)
			end
		end

	end
end