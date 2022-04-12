class CreateGithubs < ActiveRecord::Migration[6.1]
  def change
    create_table :githubs do |t|
      t.string :project
      t.string :url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
