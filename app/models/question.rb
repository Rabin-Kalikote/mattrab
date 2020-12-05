class Question < ApplicationRecord
  belongs_to :note, optional: true
  belongs_to :user
  belongs_to :grade
  belongs_to :category
  has_many :answers, dependent: :delete_all

  validates :content, presence: true

  acts_as_votable
  acts_as_taggable_on :tags
  after_create :create_notifications

  include PgSearch
  pg_search_scope :search, against: [:content],
    using: {tsearch: {dictionary: 'english'}},
    associated_against: {user: :name, answers: :content}

  def to_param
    "#{id} #{content.truncate(170)}".parameterize
  end

  def top_ans
    self.answers.sort_by{ |answer| answer.get_upvotes.size }.last
  end

  def create_notifications
    if self.note.present?
      Notification.create(recipient: self.note.user, actor: self.user, action: 'questioned', notifiable: self.note)
    else
      self.user.following.each do |recipient|
        Notification.create(recipient: recipient, actor: self.user, action: 'asked', notifiable: self)
      end
    end
  end
end
