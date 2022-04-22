class RenameTableGithubsToProjects < ActiveRecord::Migration[6.1]
  def change
    rename_table :githubs, :projects
    add_column :projects, :description, :string
  end
end
