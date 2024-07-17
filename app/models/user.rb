class User < ApplicationRecord

  PERMITTED_ATTRIBUTES = %i(name email password password_confirmation birthday gender)
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

  scope :sort_by_name, ->{order(:name)}

  has_secure_password

  attr_accessor :remember_token, :activation_token

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
