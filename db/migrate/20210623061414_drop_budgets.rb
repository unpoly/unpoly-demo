class DropBudgets < ActiveRecord::Migration[6.0]
  def up
    drop_table :budgets

    add_column :projects, :budget, :integer
  end

  def down
    remove_column :projects, :budgets

    create_table "budgets", id: :serial, force: :cascade do |t|
      t.string "name"
      t.integer "amount"
      t.integer "project_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "tenant_id"
    end
  end
end
