module Sequel
  module Plugins
    module Timestamped
      def self.apply(model, options = {})
        using = options[:using] || :localtime
        model.class_eval "before_create { self.created_at = Time.now.#{using} if self.created_at.nil? }" if model.columns.include?(:created_at)
        model.class_eval "before_save { self.updated_at = Time.now.#{using} }" if model.columns.include?(:updated_at)
      end
    end
  end
end
