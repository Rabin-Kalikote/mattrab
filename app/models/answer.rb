class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  after_create :create_notifications

  def create_notifications
    Notification.create(recipient: self.question.note.user, actor: self.user, action: 'answered', notifiable: self.question.note)
    Notification.create(recipient: self.question.user, actor: self.user, action: 'answered', notifiable: self.question.note)
  end
end
