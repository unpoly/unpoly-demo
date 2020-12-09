class Budget < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :project

  validates :name, presence: true
  validates :amount, presence: true
end
