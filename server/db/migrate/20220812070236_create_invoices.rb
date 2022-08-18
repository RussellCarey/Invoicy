class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.timestamps
      t.string :title, null: false
      t.datetime :issue_date, default: DateTime.now, null: false
      t.datetime :due_date, null: false
      t.datetime :last_send_date
      t.integer :status, null: false, default: 0
      t.integer :discount, null: false, default: 0
      t.float :tax, null: false, default: 0
    end
  add_reference :invoices, :client, foreign_key: true, null: false
  end
end
