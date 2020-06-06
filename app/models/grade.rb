class Grade < ApplicationRecord
  validates :name, presence: true
  enum name: [:twelve, :eleven, :ten, :nine, :eight, :seven]
  has_many :users
  has_many :grade_categorizations, dependent: :destroy
  has_many :categories, through: :grade_categorizations
  has_many :notes
  has_many :questions
end
