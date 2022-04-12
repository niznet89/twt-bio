class AddEthChecksumToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :eth_checksum, :string
  end
end
