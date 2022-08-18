class AddPreTotalToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :pre_total, :float
  end
end