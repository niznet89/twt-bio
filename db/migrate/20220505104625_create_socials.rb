class CreateSocials < ActiveRecord::Migration[6.1]
  def change
    create_table :socials do |t|
      t.string :instagram
      t.string :github
      t.string :tiktok
      t.string :medium
      t.string :facebook
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
