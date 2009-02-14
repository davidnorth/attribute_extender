module AttributeExtender

  def self.included(base)
    base.send :extend, ClassMethods
    base.has_many :extra_attribute_values, :as => :extendable
    base.after_save :save_extra_attribute_values
    base.cattr_accessor :extra_attributes
  end
  
  
  module ClassMethods

    def has_extra_attribute(attribute_name, type = :string, options = {})
      # Extra attribute settings are stored in hash on the class
      self.extra_attributes ||= {}
      extra_attributes[attribute_name] = {:type => type}.update(options)
      # Add attribute accessor methods so the extra attribute behaves like a regular attribute
      define_method(attribute_name) do
        read_extra_attribute_value(attribute_name)
      end
      define_method("#{attribute_name}=") do |value|
        write_extra_attribute_value(attribute_name, value)
      end
    end

  end


  def read_extra_attribute_value(attribute_name)
    extra_attribute_value_for_attribute(attribute_name).attribute_value
  end

  def write_extra_attribute_value(attribute_name, value)
    extra_attribute_value_for_attribute(attribute_name).attribute_value = value
  end

  # Fetches or creates the record that holds this exta attribute's value
  def extra_attribute_value_for_attribute(attribute_name)
    efv = extra_attribute_values.detect{|efv| efv.attribute_name.to_sym == attribute_name}
    if efv.nil?  
      efv = extra_attribute_values.build(:attribute_name => attribute_name.to_s)
      efv.extendable = self
      efv.attribute_value = self.class.extra_attributes[attribute_name][:default]
      efv.save
    end
    efv
  end

  def save_extra_attribute_values
    extra_attribute_values.each(&:save)
  end


end