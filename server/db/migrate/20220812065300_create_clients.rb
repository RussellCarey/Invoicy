class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.integer :phone_number
      t.text :note
      t.boolean :is_active

      t.integer :address_number
      t.string :address_city
      t.string :address_street
      t.string :address_county
      t.string :address_postcode
      t.timestamps
    end
    add_reference :clients, :user, foreign_key: true, null: false
  end
end
