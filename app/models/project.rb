class Project < ActiveRecord::Base
  has_many :budgets
  belongs_to :company
  accepts_nested_attributes_for :budgets

  validates :name, presence: true
  validates :company_id, presence: true

  def self.suggest_name
    Faker::App.name
  end

end
