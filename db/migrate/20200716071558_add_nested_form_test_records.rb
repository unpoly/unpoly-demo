class AddNestedFormTestRecords < ActiveRecord::Migration[4.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :company_id
      t.timestamps
    end

    create_table :budgets do |t|
      t.string :name
      t.integer :amount
      t.integer :project_id
      t.timestamps
    end

    create_table :companies do |t|
      t.string :name
      t.text :address
      t.timestamps
    end
  end
end
