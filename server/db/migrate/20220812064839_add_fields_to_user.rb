class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :phone_number, :integer
    add_column :users, :company_name, :string
    add_column :users, :address_number, :integer
    add_column :users, :address_street, :string
    add_column :users, :address_city, :string
    add_column :users, :address_county, :string
    add_column :users, :address_postcode, :string
  end
end
