class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.string :eth_message
      t.string :eth_address
      t.string :eth_signature

      t.timestamps
    end
  end
end
