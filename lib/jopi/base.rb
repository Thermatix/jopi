
module Jopi
	module Store

		class << self
			attr_accessor :data

            def method_missing name
                if self.data.has_key?(name)
                    self.data[name]
                else
                    super
                end
            end
		end

        self.data = {}


	end

	class Base
		include DSL
		attr_accessor :name,:document_tree, :branch
		class << self		
			def define key,&script
                store_type = :"#{self.class.to_s.downcase + 's'}"
				Store.data[store_type][key] = self.new(name).instance_eval(&script)			
			end
		end



		def initialize name
            self.name = name
			self.branch = []
		end

		def add_to_tree key,value
			if in_branch
				add_to_end_of_branch key, value
			else
				self.document_tree[key] = value
			end
		end

		

		private#-------------------------------------------------------
		def in_branch
			!self.branch.empty?
		end

        def add_to_end_of_branch value_key, value,tree=nil compair_with=nil
            compair_with ||= self.branch.first
            tree ||= self.tree
            tree.each_key do |key|
                if key == compair_with
                    if compair_with === self.branch.last
                        update_with = { value_key => value}
                        if tree[key].respond_to?(:keys)
                            tree[key].update(update_with)
                        else
                            tree[key] = update_with
                        end
                    else
                        next_step = self.branch.index(compair_with) + 1
                        tree[key] = walk_tree(value_key, value, tree[compair_with], self.branch[next_step])                    
                    end
                end
            end
        end

	end
end

def walk_tree tree,branch,value_key, value, compair_with=nil
    compair_with ||= branch.first
    tree.each_key do |key|
        if key == compair_with
            index_of_branch = branch.index(compair_with) 
            if branch[index_of_branch] === branch.last
                update_with = { value_key => value}
                if tree[key].respond_to?(:keys)
                    tree[key].update(update_with)
                else
                    tree[key] = update_with
                end
            else
                tree[key] = walk_tree(tree[compair_with], branch, value_key, value, branch[index_of_branch + 1])
            end
        end
    end
end