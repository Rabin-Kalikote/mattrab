class AddDetailsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :about, :text
  end
end
