class AddCategoryToChapter < ActiveRecord::Migration[5.1]
  def change
    add_reference :chapters, :category, foreign_key: true
  end
end
