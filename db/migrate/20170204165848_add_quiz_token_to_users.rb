class AddQuizTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :quiz_token, :string
  end
end
