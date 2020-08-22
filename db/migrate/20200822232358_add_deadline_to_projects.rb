class AddDeadlineToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :deadline, :date
  end
end
