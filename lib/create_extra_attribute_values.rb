class CreateExtraAttributeValues < ActiveRecord::Migration
  def self.up
    create_table :extra_attribute_values do |t|

      t.integer :extendable_id
      t.string :extendable_type
      
      t.string :field_name
      
      t.integer :integer_value
      t.boolean :boolean_value, :default => false
      t.text :string_value

    end
  end

  def self.down
    drop_table :extra_field_values
  end
end
