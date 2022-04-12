class User < ApplicationRecord
  validates :eth_address, presence: true, uniqueness: true
  validates :eth_nonce, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  has_many :githubs, dependent: :destroy
  def to_param
    username
  end
end
