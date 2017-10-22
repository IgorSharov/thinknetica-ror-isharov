# frozen_string_literal: true

class CreateAuthAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :auth_accounts do |t|
      t.references :user, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end

    add_index :auth_accounts, %i[provider uid]
  end
end
