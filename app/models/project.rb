class Project < ApplicationRecord
  validates :name, presence: true
  validates :description, length: { maximum: 200,
    too_long: "200 characters is the maximum allowed" }
  belongs_to :user
end
