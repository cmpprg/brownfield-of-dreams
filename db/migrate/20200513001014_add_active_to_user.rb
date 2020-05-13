class AddActiveToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :activation_status, :integer, default: 0
  end
end
