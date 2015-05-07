class AddEmailToDigestions < ActiveRecord::Migration
  def change
    add_column :digestions, :email, :string
  end
end
