class CreateInvoiceItems < ActiveRecord::Migration[7.0]
  def change
    create_table :invoice_items do |t|
      t.timestamps
      t.string :details, null: false, limit: 50
      t.float :amount, null: false
      t.float :price, null: false
      t.float :total, null: false
    end
    add_reference :invoice_items, :invoice, foreign_key: true
  end
end
