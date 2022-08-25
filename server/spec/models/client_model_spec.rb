require 'rails_helper'
require 'api_helper'

RSpec.describe Client do

    context 'validations' do
        let(:client) { Fabricate(:client) }

         it 'checks presence validation is on the columns' do
            expect(client).to validate_presence_of :email
            expect(client).to validate_presence_of :first_name
            expect(client).to validate_presence_of :last_name
            expect(client).to validate_presence_of :address_city
            expect(client).to validate_presence_of :address_county
            expect(client).to validate_presence_of :address_number
            expect(client).to validate_presence_of :address_street
            expect(client).to validate_presence_of :address_postcode
            expect(client).to validate_presence_of :user_id
        end

        it 'has the correct relations on the model' do
            expect(client).to belong_to :user
            expect(client).to have_many :invoices
        end

        it 'fails validation if not an email' do
            client.email = "notanemailcom"

            expect(client).to_not be_valid
            expect(client.errors.full_messages).to include("Email is invalid")
        end

        it 'fails validation if names are too long' do 
            client.first_name = "Thisisanamethatislongerthan20"
            client.last_name = "Thisisanamethatislongerthan20"

            expect(client).to_not be_valid
            expect(client.errors.full_messages[0]).to include("First name is too long")
            expect(client.errors.full_messages[1]).to include("Last name is too long")
        end

        it 'fails validation if names are too short' do  
            client.first_name = "bo"
            client.last_name = "po"           

            expect(client).to_not be_valid
            expect(client.errors.full_messages[0]).to include("First name is too short")
            expect(client.errors.full_messages[1]).to include("Last name is too short")
        end

        it 'fails if house number is out of range' do
            client_two = Fabricate(:client)
            client.address_number = 1000
            client_two.address_number = -100
            
            expect(client).to_not be_valid
            expect(client_two).to_not be_valid

            expect(client.errors.full_messages[0]).to include("Address number must be in")
            expect(client_two.errors.full_messages[0]).to include("Address number must be in")
        end

        it 'fails validation if street name is too long or too short' do  
            client_two = Fabricate(:client) 
            client.address_street = "thisnameislongthattheamountithinksoiwillstopnow"
            client_two.address_street = "po"           

            expect(client).to_not be_valid
            expect(client_two).to_not be_valid

            expect(client.errors.full_messages[0]).to include("Address street is too long")
            expect(client_two.errors.full_messages[0]).to include("Address street is too short")

        end

        it 'fails validation if city name is too long or too short' do  
            client_two = Fabricate(:client) 
            client.address_street = "thisnameislongthattheamountithinksoiwillstopnow"
            client_two.address_street = "po"           

            expect(client).to_not be_valid
            expect(client_two).to_not be_valid

            expect(client.errors.full_messages[0]).to include("Address street is too long")
            expect(client_two.errors.full_messages[0]).to include("Address street is too short")

        end

        it 'fails validation if county name is too long or too short' do  
            client_two = Fabricate(:client) 
            client.address_county = "thisnameislongthattheamountithinksoiwillstopnow"
            client_two.address_county = "po"           

            expect(client).to_not be_valid
            expect(client_two).to_not be_valid

            expect(client.errors.full_messages[0]).to include("Address county is too long")
            expect(client_two.errors.full_messages[0]).to include("Address county is too short")

        end

        it 'fails validation if postcode name is too long or too short' do  
            client_two = Fabricate(:client) 
            client.address_postcode = "po212nnssdifnsdf"
            client_two.address_postcode = "p"           

            expect(client).to_not be_valid
            expect(client_two).to_not be_valid

            expect(client.errors.full_messages[0]).to include("Address postcode is too long")
            expect(client_two.errors.full_messages[0]).to include("Address postcode is too short")

        end
    end
end