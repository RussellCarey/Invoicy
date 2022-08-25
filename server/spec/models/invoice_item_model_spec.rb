require 'rails_helper'

RSpec.describe InvoiceItem do
    context 'validations' do
        let(:client) { Fabricate(:client ) }
        let(:invoice) { Fabricate(:invoice, client_id: client.id) }
        let(:invoice_item) { Fabricate(:invoice_item, invoice_id: invoice.id) }

        it 'has correct relations' do
            expect(invoice_item).to belong_to :invoice
        end

        it 'fails if there is no presence validations' do
            expect(invoice_item).to validate_presence_of :details
        end
    end

    context 'methods' do
        it 'sets default values if none have been entered ' do
            invoice_item = InvoiceItem.create() 
            expect(invoice_item.amount).to eq 0
            expect(invoice_item.price).to eq 0
        end        
    end
end
