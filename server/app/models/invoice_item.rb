# Fields
# t.string :details
# t.float :amount
# t.float :price
# t.float :total

class InvoiceItem < ApplicationRecord
    belongs_to :invoice

    after_initialize :defaults
    after_create :update_parent_invoice_total
    after_update :update_parent_invoice_total

    validates :details, presence: :true, length: {minimum: 3, maximum: 50}
    validates :amount, presence: :true
    validates :price, presence: :true

    private
    def defaults
        self.amount ||= 0
        self.price ||= 0
        self.total = self.amount * self.price
    end

    # Update parent Invoice total amount
    def update_parent_invoice_total
        invoice.pre_total = invoice.get_total
        invoice.total = invoice.get_total
        invoice.total -= invoice.calculate_percentage_of_discount 
        invoice.total += invoice.calculate_percentage_of_tax 
        invoice.save
    end
end
