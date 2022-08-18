class AddUserIdToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :user_id, :integer, null: false, default: 0
  end
end
