module Sequel
  module Plugins
    module Timestamped
      def self.apply(model, options = {})
        using = options[:using] || :localtime
        model.class_eval "def before_create; super; self.created_at = Time.now.#{using} if self.created_at.nil?; end" if model.columns.include?(:created_at)
        model.class_eval "def before_save; super; self.updated_at = Time.now.#{using}; end" if model.columns.include?(:updated_at)
      end
    end
  end
end
