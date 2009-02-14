class ExtraAttributeValue < ActiveRecord::Base
  
  belongs_to :extendable, :polymorphic => true
  validates_presence_of :extendable
  
  def value_column
    @value_column ||= extendable.class.extra_attributes[attribute_name.to_sym][:type].to_s + '_value'
  end
  
  def attribute_value
    send(value_column)
  end
  
  def attribute_value=(value)
    self.send("#{value_column}=", value)
  end  
  
end
