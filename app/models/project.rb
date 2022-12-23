class Project < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :company

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :tenant_id }
  validates :company_id, presence: true
  validates :budget, numericality: { greater_than_or_equal_to: 100 }

  def self.suggest_name
    Faker::App.unique.name
  end

end
