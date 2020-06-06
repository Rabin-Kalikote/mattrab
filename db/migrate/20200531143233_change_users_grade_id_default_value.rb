class ChangeUsersGradeIdDefaultValue < ActiveRecord::Migration[5.1]
  def up
    change_column :users, :grade_id, :bigint, default: 1
  end

  def down
    change_column :users, :grade_id, :bigint, default: nil
  end
end
