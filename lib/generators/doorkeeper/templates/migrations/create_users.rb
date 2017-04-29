class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :oauth_users do |t|
      ## Info
      t.string :name,               null: false, default: ''
      t.string :uid,                null: false, default: ''
      t.string :email,              null: false, default: ''

      ## Database authenticatable
      t.string :password_digest,    null: false, default: ''
    end

    add_index :oauth_users, :name, unique: true
    add_index :oauth_users, :uid, unique: true
    add_index :oauth_users, :email, unique: true
  end
end
