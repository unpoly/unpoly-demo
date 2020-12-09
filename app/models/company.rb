class Company < ActiveRecord::Base
  belongs_to :tenant
  has_many :projects, dependent: :restrict_with_error

  validates :name, presence: true
end
