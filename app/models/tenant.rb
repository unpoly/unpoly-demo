class Tenant < ApplicationRecord

  has_many :companies, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :projects, dependent: :destroy

  after_create :create_sample_records

  # If we change the schema we recreate new tenants
  has_defaults schema_version: -> { self.class.schema_version }

  scope :for_current_schema, -> { where(schema_version: schema_version)}

  def self.schema_version
    connection.migration_context.current_version
  end

  private

  def create_sample_records
    5.times do
      company = companies.create!(
        name: Faker::Company.name,
        address: sample_address
      )

      (2..3).to_a.sample.times do
        project = projects.create!(
          company: company,
          name: Project.suggest_name
        )

        (2..3).to_a.sample.times do
          budgets.create!(
            project: project,
            amount: ((1..150).to_a.sample * 1000),
            name: Faker::Commerce.product_name
          )
        end
      end
    end
  end

  def sample_address
    <<~ADDRESS
      #{Faker::Address.street_name} #{rand(100) + 1}
      #{Faker::Address.postcode} #{Faker::Address.city}
      #{Faker::Address.country}
    ADDRESS
  end

end

