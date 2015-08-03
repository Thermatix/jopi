require "jopi/version"

module Jopi

end

%w{dsl base document mixin object template render}.each do |file|
	require "jopi/#{file}"
end
