class AddStarToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :star, :boolean
  end
end
