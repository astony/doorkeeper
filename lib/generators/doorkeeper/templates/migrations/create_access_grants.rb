class CreateAccessGrants < ActiveRecord::Migration[5.0]
  def change
    create_table :oauth_access_grants do |t|
      t.integer     :resource_owner_id, null: false
      t.references  :application,       null: false
      t.string      :token,             null: false
      t.integer     :expires_in,        null: false
      t.text        :redirect_uri,      null: false
      t.datetime    :created_at,        null: false
      t.datetime    :revoked_at
      t.string      :scopes
    end

    add_index :oauth_access_grants, :token, unique: true
    add_foreign_key(
        :oauth_access_grants,
        :oauth_applications,
        column: :application_id
    )
  end
end
