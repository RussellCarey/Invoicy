require 'rails_helper'

RSpec.describe InvoiceItem do
    context 'validations' do
        let(:user) { Fabricate(:user ) }

        it 'has correct relations' do
            expect(user).to have_many :clients
        end

        it 'fails if there is no presence validations' do
            expect(user).to validate_presence_of :email
        end

        it 'fails validation if not an email' do
            user.email = "notanemailcom"
            expect(user).to_not be_valid
            expect(user.errors.full_messages).to include("Email is invalid")
        end
    end
end
