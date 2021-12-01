class IndexForeignKeys < ActiveRecord::Migration[6.0]
  def change
    add_index :companies, [:tenant_id, :name] # companies index
    add_index :projects, [:tenant_id, :name] # projects index
    add_index :projects, :company_id # company has_many projects
    add_index :tasks, [:tenant_id, :created_at] # tasks index
  end
end
