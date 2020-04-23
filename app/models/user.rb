class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :notes, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :notifications, foreign_key: :recipient_id

  acts_as_voter
  enum role: [:learner, :creator, :admin]
  enum admin_category: [:category, :physics, :chemistry, :biology, :maths, :computer, :english, :nepali, :pastpapers, :solution]
  enum grade: [:twelve, :eleven, :teacher]

  def to_param
    "#{id} #{name}".parameterize
  end

  ## helper methods
  # follow another user
  def follow(other)
    active_relationships.create(followed_id: other.id)
  end
  # unfollow a user
  def unfollow(other)
    active_relationships.find_by(followed_id: other.id).destroy
  end
  # is following a user?
  def following?(other)
    following.include?(other)
  end

  has_attached_file :avatar, styles: {pro: "250x250#", medium: "70x70>", small: "35x35>" }, default_url: "/images/pro/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
end
