class Github < ApplicationRecord
  validates :project, presence: true
  belongs_to :user
end
