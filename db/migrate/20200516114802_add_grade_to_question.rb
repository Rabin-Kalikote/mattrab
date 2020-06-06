class AddGradeToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_reference :questions, :grade, foreign_key: true
  end
end
