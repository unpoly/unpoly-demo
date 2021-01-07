class Company < ActiveRecord::Base
  belongs_to :tenant
  has_many :projects, dependent: :destroy

  validates :name, presence: true
end
