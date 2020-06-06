class AddGradeToNote < ActiveRecord::Migration[5.1]
  def change
    add_reference :notes, :grade, foreign_key: true
  end
end
