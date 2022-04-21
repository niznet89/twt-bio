class CreateWidgets < ActiveRecord::Migration[6.1]
  def change
    create_table :widgets do |t|
      t.boolean :mirror
      t.boolean :nfts
      t.boolean :projects
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
