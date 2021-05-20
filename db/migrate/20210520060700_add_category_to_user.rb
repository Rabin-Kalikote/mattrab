class AddCategoryToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :category, foreign_key: true, default: 1
  end
end
