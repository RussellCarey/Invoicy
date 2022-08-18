#Fields
# t.string :email
# t.string :first_name
# t.string :last_name
# t.integer :phone_number
# t.text :note
# t.boolean :is_active
# t.integer :address_number
# t.string :address_city
# t.string :address_street
# t.string :address_county
# t.string :address_postcode

class Client < ApplicationRecord
    belongs_to :user
    has_many :invoices

    #Validations
    validates :email, presence: :true
    validates :first_name, presence: :true
    validates :last_name, presence: :true
    validates :address_number, presence: :true
    validates :address_street, presence: :true
    validates :address_city, presence: :true
    validates :address_county, presence: :true
    validates :address_postcode, presence: :true
    validates :user_id, presence: :true
end


