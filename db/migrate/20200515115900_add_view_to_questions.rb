class AddViewToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :view, :int, default: 0
  end
end
