module Sequel
  module Plugins
    module Cascading
      def self.apply(model, options = {})
        Array(options[:destroy]).each do |assoc|
          model.instance_eval "before_destroy { #{assoc}_dataset.destroy }"
        end
        Array(options[:nullify]).each do |assoc|
          model.instance_eval "before_destroy { remove_all_#{assoc} }"
        end
        Array(options[:restrict]).each do |assoc|
          model.instance_eval "before_destroy { raise Error::InvalidOperation, 'Delete would orphan associated #{assoc}' unless #{assoc}_dataset.empty? }"
        end
      end
    end
  end
end
