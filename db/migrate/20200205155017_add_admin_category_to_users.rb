class AddAdminCategoryToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin_category, :integer, default: 0
  end
end
