class AddValidationToClients < ActiveRecord::Migration[7.0]
  def change
    change_column :clients, :email, :string, unique: true
  end
end
