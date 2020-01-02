class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string

    add_column :users, :otp_secret_key, :string
    add_column :users, :otp_module, :integer, default: 0

    add_column :users, :provider, :string
    add_column :users, :uid, :string

    add_index :users, :username, unique: true
  end
end
