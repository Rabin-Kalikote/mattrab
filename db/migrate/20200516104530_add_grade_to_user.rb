class AddGradeToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :grade, foreign_key: true
  end
end
