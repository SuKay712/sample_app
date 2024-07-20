class User < ApplicationRecord
  has_many :microposts, dependent: :destroy

  has_many :active_relationships, class_name: Relationship.name,
            foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
            foreign_key: :followed_id, dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  PERMITTED_ATTRIBUTES = %i(name email password password_confirmation birthday gender).freeze
  before_save :downcase_email
  before_create :create_activation_digest
  validates :password, presence: true, length: {minimum: Settings.password_length}
  validates :name, presence: true, length: {maximum: Settings.name_length}
  validates :email, presence: true,
    length: {minimum: Settings.email_length_min,
            maximum: Settings.email_length_max},
    format: {with: Settings.mail_regex},
    uniqueness: {case_sensitive: false, scope: :id}
  validates :gender, presence: true
  validates :birthday, presence: true
  validate :birthday_must_be_in_last_100_years, if: ->{birthday.present?}

  scope :sort_by_name, ->{ order(:name) }

  has_secure_password

  attr_accessor :remember_token, :activation_token, :reset_token

  class << self
    def digest string
      cost =  if ActiveModel::SecurePassword::min_cost
                BCrypt::Engine::MIN_COST
              else
                BCrypt::Engine::cost
              end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticate? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.token_expire_time.hours.ago
  end

  def feed
    Micropost.relate_post(following_ids << id)
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  private

  def downcase_email
    self.email.downcase!
  end

  def birthday_must_be_in_last_100_years
    if birthday < 100.years.ago.to_date
      errors.add :birthday, :birthday_at_least
    end
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
