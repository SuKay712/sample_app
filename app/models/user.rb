class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save :downcase_email
  validates :password, presence: true, length: {minimum: 6}, if: :password
  validates :name, presence: true, length: {maximum: 10}
  validates :email, presence: true, length: {minimum: 20, maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false, scope: :name}
  validate :birthday_must_be_in_last_100_years
  has_secure_password

  private

  def downcase_email
    self.email.downcase!
  end

  def birthday_must_be_in_last_100_years
    if birthday.present? && birthday < 100.years.ago.to_date
      errors.add(:birthday, "must be in the last 100 years")
    end
  end
end
