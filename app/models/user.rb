class User < ApplicationRecord
  USER_PARAMS = %i(name email password password_confirmation).freeze
  VALID_EMAIL_REGEX = Regexp.new(Settings.user.valid_email)

  validates :name, presence: true,
    length: {maximum: Settings.user.maxlength_user_name}
  validates :email, presence: true,
    length: {maximum: Settings.user.maxlength_user_email},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  before_save :downcase_email
  has_secure_password
  attr_accessor :remember_token

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
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

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  private

  def downcase_email
    email.downcase!
  end
end
