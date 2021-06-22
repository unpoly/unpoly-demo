class Project < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :company
  has_many :budgets, dependent: :destroy

  accepts_nested_attributes_for :budgets

  validates :name, presence: true
  validates :company_id, presence: true

  def self.suggest_name
    Faker::App.name
  end

  def total_budget
    budgets.sum(&:amount)
  end

end
