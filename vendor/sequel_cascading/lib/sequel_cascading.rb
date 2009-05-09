module Sequel
  module Plugins
    module Cascading
      def self.apply(model, options = {})
        Array(options[:destroy]).each do |assoc|
          model.instance_eval "def before_destroy; super; #{assoc}_dataset.destroy; end"
        end
        Array(options[:nullify]).each do |assoc|
          model.instance_eval "def before_destroy; super; remove_all_#{assoc}; end"
        end
        Array(options[:restrict]).each do |assoc|
          model.instance_eval "def before_destroy; super; raise Error::InvalidOperation, 'Delete would orphan associated #{assoc}' unless #{assoc}_dataset.empty?; end"
        end
      end
    end
  end
end
