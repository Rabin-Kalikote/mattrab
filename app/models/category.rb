class Category < ApplicationRecord
  validates :name, presence: true
  enum name: [:physics, :chemistry, :biology, :maths, :computer, :english, :nepali, :economics, :account, :science, :social, :health, :moral, :obt, :opt_math, :pastpapers, :solution, :trivia, :philosopy]
  belongs_to :grade
  has_many :user_categorizations, dependent: :destroy
  has_many :users, through: :user_categorizations
  has_many :chapters
  has_many :notes
  has_many :questions
end
