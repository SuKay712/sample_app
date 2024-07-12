class Micropost < ApplicationRecord
  belongs_to :user, optional: true
  validates :content, presence: true, length: {maximum: Settings.micropost_content_length}
  validates :image,
            content_type: { in: Settings.image_format,
                            message: I18n.t("image.image_invalid_format") },
            size:         { less_than: Settings.max_image_data.megabytes,
                            message:  I18n.t("image.image_maximum_size",
                                        size: Settings.max_image_data.megabytes) }
  scope :sort_by_date_desc, -> { order(created_at: :desc) }

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [Settings.digit_300, Settings.digit_300]
  end

  PERMITTED_ATTRIBUTES = %i(content image)
end
