class User < ApplicationRecord
  validates :eth_address, presence: true, uniqueness: true
  validates :eth_nonce, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :description, length: { maximum: 200,
    too_long: "200 characters is the maximum allowed" }
  has_many :projects, dependent: :destroy
  has_one_attached :photo
  # After a User model is generated, create a Widget Model.
  after_create :create_widget
  after_create :create_socials
  has_one :widgets, dependent: :destroy
  has_one :socials, dependent: :destroy
  def to_param
    username
  end

  def create_widget
    Widget.create(user_id: self.id, mirror: false, nfts: false, projects: false)
  end

  def create_socials
    Social.create(user_id: self.id, instagram: nil, github: nil, tiktok: nil, medium: nil, facebook: nil)
  end
end
