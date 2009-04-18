class Sequel::Model
  # We are explicitly breaking Sequel::Model(:other_dataset) since we
  # don't plan on using it, and it comes with some very bad design
  # decisions on part of sequel.
  def self.inherited(subclass)
    ivs = subclass.instance_variables.collect{|x| x.to_s}
    EMPTY_INSTANCE_VARIABLES.each{|iv| subclass.instance_variable_set(iv, nil) unless ivs.include?(iv.to_s)}
    INHERITED_INSTANCE_VARIABLES.each do |iv, dup|
      next if ivs.include?(iv.to_s)
      sup_class_value = instance_variable_get(iv)
      sup_class_value = sup_class_value.dup if dup == :dup && sup_class_value
      subclass.instance_variable_set(iv, sup_class_value)
    end
  end
end
