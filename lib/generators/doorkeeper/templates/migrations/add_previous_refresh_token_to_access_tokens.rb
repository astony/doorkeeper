class AddPreviousRefreshTokenToAccessTokens < ActiveRecord::Migration[5.0]
  def change
    # If there is a previous_refresh_token column,
    # refresh tokens will be revoked after a related access token is used.
    # If there is no previous_refresh_token column,
    # previous tokens are revoked as soon as a new access token is created.
    # Comment out this line if you'd rather have refresh tokens
    # instantly revoked.
    add_column :oauth_access_tokens, :previous_refresh_token, :string, default: '', null: false
  end
end
