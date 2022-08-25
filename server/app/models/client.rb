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
    validates :email, presence: :true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :first_name, presence: :true, length: {minimum: 3, maximum: 20}
    validates :last_name, presence: :true, length: {minimum: 3, maximum: 20}
    validates :address_number, presence: :true, numericality: { in: 1..999 }
    validates :address_street, presence: :true, length: {minimum: 3, maximum: 30}
    validates :address_city, presence: :true, length: {minimum: 3, maximum: 20}
    validates :address_county, presence: :true, length: {minimum: 3, maximum: 20}
    validates :address_postcode, presence: :true, length: {minimum: 7, maximum: 9}
    validates :user_id, presence: :true
end


