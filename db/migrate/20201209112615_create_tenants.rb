class CreateTenants < ActiveRecord::Migration[6.0]
  def change
    create_table :tenants do |t|
      t.bigint :schema_version
    end

    add_column :companies, :tenant_id, :integer
    add_column :projects, :tenant_id, :integer
    add_column :budgets, :tenant_id, :integer
  end
end
