class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  belongs_to :grade
  has_many :user_categorizations, dependent: :destroy
  has_many :categories, through: :user_categorizations
  has_many :notes, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :answered_questions, through: :answers, source: :question

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :notifications, foreign_key: :recipient_id

  acts_as_voter
  enum role: [:learner, :creator, :admin, :teacher, :superadmin]
  enum admin_category: [:physics, :chemistry, :biology, :maths, :computer, :english, :nepali, :pastpapers, :solution]
  enum egrade: [:twelve, :eleven, :ten]

  include PgSearch
  pg_search_scope :search, against: [:name, :about],
    using: {tsearch: {dictionary: 'english'}},
    associated_against: {notes: :title, questions: :content}

  def to_param
    "#{id} #{name}".parameterize
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    where(email: data['email'], uid: access_token.uid).first_or_create(name: data['name'], email: data['email'], uid: access_token.uid, avatar_url: data['image'], confirmed_at: Time.now)
  end

  def self.new_with_session(params, session)
    if session['devise.google_data']
      new session["devise.google_data"] do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && uid.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def voted_notes
    self.get_up_voted Note.limit(11)
  end

  def feeds
    fquestions = Question.where(user_id: self.followers).where('updated_at > ?', 24.hours.ago).to_a
    nquestions = Question.where(note_id: self.notes).where('updated_at > ?', 24.hours.ago).to_a
    aquestions = Answer.where(question_id: self.questions).where('updated_at > ?', 24.hours.ago).to_a
    return [fquestions, nquestions, aquestions].reduce([], :concat).uniq.shuffle
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

  def avatar_address(size)
    if self.avatar.present?
      self.avatar.url(size)
    elsif self.uid.present?
      self.avatar_url
    else
      '/images/pro/missing.png'
    end
  end

  has_attached_file :avatar, styles: {pro: "250x250#", medium: "70x70>", small: "35x35>" }, default_url: "/images/pro/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
end
