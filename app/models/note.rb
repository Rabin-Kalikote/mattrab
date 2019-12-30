class Note < ApplicationRecord
  include SearchCop

  search_scope :search do
    attributes :title, :body
  end

  enum category: [:physics, :chemistry, :biology, :maths, :computer, :english, :nepali, :pastpapers, :solution]

  acts_as_votable
  belongs_to :user
  has_many :comments, dependent: :delete_all
  has_attached_file :image, styles: { medium: "700x500#", small: "350x250>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
