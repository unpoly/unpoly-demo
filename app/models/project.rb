class Project < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :company
  has_many :budgets

  accepts_nested_attributes_for :budgets

  validates :name, presence: true
  validates :company_id, presence: true

  has_defaults star: false

  def self.suggest_name
    Faker::App.name
  end

end
