class AddGradeToCategory < ActiveRecord::Migration[5.1]
  def change
    add_reference :categories, :grade, foreign_key: true
  end
end
