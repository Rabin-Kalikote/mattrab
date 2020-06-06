class CreateUserCategorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_categorizations do |t|
      t.references :category, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
