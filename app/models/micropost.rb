class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: [Settings.micropost.image.height,
                                         Settings.micropost.image.width]
  end
  scope :recent_posts, ->{order(created_at: :desc)}
  validates :content, presence: true, length: {maximum: Settings.digit_140}
  validates :image, content_type: {in: Settings.micropost.image.allowed_types,
                                   message: I18n.t("message.image_format")},
             size: {less_than: Settings.micropost.image.max_size.megabytes,
                    message: I18n.t("message.size_max")}
end
