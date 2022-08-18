class AddTotalToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :total, :float
  end
end
