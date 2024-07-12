class User < ApplicationRecord

  PERMITTED_ATTRIBUTES = %i(name email password password_confirmation birthday gender)
  before_save :downcase_email

  validates :password, presence: true, length: {minimum: Settings.password_length}
  validates :name, presence: true, length: {maximum: Settings.name_length}
  validates :email, presence: true,
    length: {minimum: Settings.email_length_min, maximum: Settings.email_length_max},
    format: {with: Settings.mail_regex},
    uniqueness: {case_sensitive: false, scope: :id}
  validates :gender, presence: true
  validates :birthday, presence: true
  validate :birthday_must_be_in_last_100_years, if: -> {birthday.present?}
  validates :gender, presence: true
  validates :birthday, presence: true
  validate :birthday_must_be_in_last_100_years, if: -> {birthday.present?}

  has_secure_password

  def User.digest string
    cost =  if ActiveModel::SecurePassword::min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine::cost
            end
    BCrypt::Password.create string, cost: cost
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
