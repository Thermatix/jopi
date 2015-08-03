module Jopi
	module DSL
		def data *args
			case args.length
			when 2
				data_objects *args
			when 3
				data_multi_objects *args
			end
		end

		def data_objects type, object_name

		end

		def data_multi_objects type, key, object_names

		end
	end
		
	class Object < Base
		
	end
end