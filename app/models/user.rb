class User < ApplicationRecord

  PERMITTED_ATTRIBUTES = %i(name email password password_confirmation birthday gender)
  before_save :downcase_email

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

  attr_accessor :remember_token

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

  def authenticate? remember_token
    return false unless remember_token

    BCrypt::Password.new(remember_digest).is_password? remember_token
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
end
