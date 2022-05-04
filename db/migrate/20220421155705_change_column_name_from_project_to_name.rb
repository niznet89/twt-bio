class ChangeColumnNameFromProjectToName < ActiveRecord::Migration[6.1]
  def change
    rename_column :projects, :project, :name
  end
end
