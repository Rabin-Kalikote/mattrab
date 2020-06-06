class AddCategoryToNote < ActiveRecord::Migration[5.1]
  def change
    add_reference :notes, :category, foreign_key: true
  end
end
