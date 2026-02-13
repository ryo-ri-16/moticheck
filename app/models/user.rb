class User < ApplicationRecord
  has_many :lists, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :list_templates, dependent: :destroy
  has_many :notifications, dependent: :destroy
  devise :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :validatable,
          :omniauthable, omniauth_providers: %i[google_oauth2]

  after_create :create_default_category

  scope :guests, -> { where(guest: true) }
  scope :expired_guests, -> {
    guests.where("guest_created_at < ?", 14.days.ago)
  }

  def can_create_more_lists?
    return true unless guest?
    lists.count < 8
  end

  def can_copy?
    !guest?
  end

  def guest?
    guest == true
  end

  def convert_to_registration!(name:, email:, password:, password_confirmation:)
    return false unless guest?

    transaction do
      update!(
        name: name,
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        guest: false,
        guest_created_at: nil
      )
    end
  end

  GUEST_LIST_LIMIT = 8

  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    user = find_by(email: auth.info.email, guest: false)
    if user
      user.update!(
        provider: auth.provider,
        uid: auth.uid
      )
      return user
    end

    create!(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      name: auth.info.name,
      guest: false
    )
  end

  def convert_to_google!(auth)
    return false unless guest?

    existing_user = User.find_by(provider: auth.provider, uid: auth.uid)
    if existing_user
      errors.add(:base, "このGoogleアカウントは既に登録されています")
      return false
    end

    if User.where.not(id: id).exists?(email: auth.info.email, guest: false)
      errors.add(:base, "このメールアドレスは既に登録されています")
      return false
    end

    self.provider = auth.provider
    self.uid = auth.uid
    self.email = auth.info.email
    self.name = auth.info.name
    self.guest = false
    self.guest_created_at = nil
    self.password = Devise.friendly_token[0, 20]  # OAuth用のダミーパスワード

    save
  end

  private

  def create_default_category
    categories.find_or_create_by!(name: "未分類")
  end
end
