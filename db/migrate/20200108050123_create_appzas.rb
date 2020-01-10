class CreateAppzas < ActiveRecord::Migration[6.0]
  def change
    create_table :appzas do |t|
      t.string :name, default: ""
      t.string :url, default: ""
      t.string :callback_url, default: ""
      t.string :accept_header, default: ""
      t.string :secret, default: ""
      t.text :requires, array: true
      t.integer :user_id

      t.timestamps
    end

    add_index :appzas, :secret, unique: true
  end
end
