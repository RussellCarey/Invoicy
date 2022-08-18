class AddSubscriptionIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :member_id, :string
  end
end
