require 'rails_helper'

RSpec.describe Invoice do
    context 'validations' do
        let(:client) { Fabricate(:client ) }
        let(:invoice) { Fabricate(:invoice, client_id: client.id) }

        it 'has correct relations' do
            expect(invoice).to belong_to :client
            expect(invoice).to have_many :invoice_items
        end

        it 'fails if there is no presence validations' do
            expect(invoice).to validate_presence_of :title
            expect(invoice).to validate_presence_of :issue_date
            expect(invoice).to validate_presence_of :due_date
            expect(invoice).to validate_presence_of :status
            expect(invoice).to validate_presence_of :client_id
        end

        it 'fails if it goes not have the correct relations' do
            expect(invoice).to belong_to :client
            expect(invoice).to have_many :invoice_items
        end

        it 'fails if the title length is out of range' do
            expect(invoice.title.length).to be > 1
            expect(invoice.title.length).to be < 31
        end

        it 'fails if tax is out of range' do
            expect(invoice.tax).to be >= 0
            expect(invoice.tax).to be <= 100
        end

        it 'fails if discount is out of range' do
            expect(invoice.discount).to be >= 0
            expect(invoice.discount).to be <= 100
        end

        it 'fails if due date is less than current day' do
            expect(invoice.due_date).to be >= Date.today
        end
    end

    context 'helper methods' do
        let(:user) { Fabricate(:user ) }
        let(:client) { Fabricate(:client, user_id: user.id ) }
        let(:invoice) { Fabricate(:invoice, client_id: client.id, user_id: user.id ) }
        
        it 'sets discount and tax to 0 if nothing is entered' do
             expect(invoice.tax).to eq 0
             expect(invoice.discount).to eq 0
        end

        #! Why is this failing?
        # it 'adds to the total when invoice items are added' do
        #     expect(invoice.total).to eq 0
        #     invoice_item = InvoiceItem.create(details: "Test title", amount: 10, price: 10, invoice_id: invoice.id)
        #     expect(invoice.total).to eq 100
        # end

        it 'calculates discount correctly for the total' do
            invoice.discount = 50
            invoice.total = 100
            discounted = invoice.calculate_percentage_of_discount
            invoice.total = discounted
            expect(invoice.total).to eq 50
        end

        it 'calculates tax correctly for the total' do
            invoice.tax = 50
            invoice.total = 100
            taxed = invoice.calculate_percentage_of_tax
            invoice.total = taxed
            expect(invoice.total).to eq 50
        end
    end
end


#     scope :filter_by_status, -> (status) { where("status = ?", status) }
#     scope :filter_due_date, -> (due_date) { where("due_date = ?", due_date) }
#     scope :filter_due_date_gt, -> (due_date) { where("due_date > ?", due_date) }
#     scope :filter_due_date_lt, -> (due_date) { where("due_date < ?", due_date) }
#     scope :filter_issue_date, -> (issue_date) { where("issue_date = ?", issue_date) }
#     scope :filter_issue_date_gt, -> (issue_date) { where("issue_date > ?", issue_date) }
#     scope :filter_issue_date_lt, -> (issue_date) { where("issue_date < ?", issue_date) }
#     scope :filter_total, -> (total) { where("total = ?", total) }
#     scope :filter_total_lt, -> (total) { where("total < ?", total) }
#     scope :filter_total_gt, -> (total) { where("total > ?", total) }
