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
			add_to_tree :data, { type: type,
				object: ::Store.objects[object_name].get_tree
			}
		end

		def data_multi_objects type, key, object_names
			add_to_tree :data, {
				type: :type,

			}
		end
	end

	class Object < Base
		def get_tree

		end
	end
end