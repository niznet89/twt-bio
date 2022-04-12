class AddUserForeignKeyToGithub < ActiveRecord::Migration[6.1]
  def change
    add_reference :githubs, :user, foreign_key: true
  end
end
