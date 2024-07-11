class User < ApplicationRecord
  before_save :downcase_email

  validates :password, presence: true, length: {minimum: Settings.password_length}
  validates :name, presence: true, length: {maximum: Settings.name_length}
  validates :email, presence: true, length: {minimum: Settings.email_length_min, maximum: Settings.email_length_max},
    format: {with: Settings.mail_regex},
    uniqueness: {case_sensitive: false, scope: :id}
  validate :birthday_must_be_in_last_100_years, if: :birthday.present?

  has_secure_password

  private

  def downcase_email
    self.email.downcase!
  end

  def birthday_must_be_in_last_100_years
    if birthday < 100.years.ago.to_date
      errors.add(:birthday, t("users.birthday_at_least"))
    end
  end
end
