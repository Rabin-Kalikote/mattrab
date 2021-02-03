class DropGradeCategorizations < ActiveRecord::Migration[5.1]
  def change
    drop_table :grade_categorizations do |t|
      t.references :category, foreign_key: true
      t.references :grade, foreign_key: true

      t.timestamps
    end
  end
end
