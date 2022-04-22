class User < ApplicationRecord
  validates :eth_address, presence: true, uniqueness: true
  validates :eth_nonce, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  has_many :projects, dependent: :destroy
  # After a User model is generated, create a Widget Model.
  after_create :create_widget
  def to_param
    username
  end

  def create_widget
    Widget.create(user_id: self.id, mirror: false, nfts: false, projects: false)
  end
end
