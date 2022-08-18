class AddTokensAndMembershipToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :credits, :integer, default: 0
    add_column :users, :is_member, :boolean, default: false
  end
end
