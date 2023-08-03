class AddAuthTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :auth_token, :string
    add_column :users, :name, :string
  end
end
