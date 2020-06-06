class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :content, presence: true

  acts_as_votable
  after_create :create_notifications

  def to_param
    "#{id} #{content.truncate(170)}".parameterize
  end

  def create_notifications
    if self.question.note.present?
      Notification.create(recipient: self.question.note.user, actor: self.user, action: 'answered', notifiable: self.question.note)
      Notification.create(recipient: self.question.user, actor: self.user, action: 'answered', notifiable: self.question.note)
    else
      Notification.create(recipient: self.question.user, actor: self.user, action: 'answered', notifiable: self.question)
    end
  end
end
