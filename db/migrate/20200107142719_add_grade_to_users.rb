class AddGradeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :grade, :integer, default: 0
  end
end
