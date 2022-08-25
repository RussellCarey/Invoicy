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
        let(:invoice_item) { InvoiceItem.create() }

        it 'sets default values if none have been entered ' do
            expect(invoice_item.amount).to eq 0
            expect(invoice_item.price).to eq 0
        end
        
    end
end


# Fields
# t.string :details
# t.float :amount
# t.float :price
# t.float :total

# class InvoiceItem < ApplicationRecord
#     belongs_to :invoice

#     after_initialize :defaults
#     after_create :update_parent_invoice_total
#     after_update :update_parent_invoice_total

#     validates :details, presence: :true, length: {minimum: 3, maximum: 50}

#     private
#     def defaults
#         self.amount ||= 0
#         self.price ||= 0
#         self.total = self.amount * self.price
#     end

#     # Update parent Invoice total amount
#     def update_parent_invoice_total
#         invoice.pre_total = invoice.get_total
#         invoice.total = invoice.get_total
#         invoice.total -= invoice.calculate_percentage_of_discount 
#         invoice.total += invoice.calculate_percentage_of_tax 
#         invoice.save
#     end
# end
