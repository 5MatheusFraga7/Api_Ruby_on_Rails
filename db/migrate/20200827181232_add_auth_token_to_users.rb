#rails g migration add_auth_token_to_users auth_token:string
class AddAuthTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :auth_token, :string	
    add_index :users, :auth_token, unique: true
  end
end
