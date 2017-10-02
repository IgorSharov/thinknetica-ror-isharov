# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, index: true
      t.references :user, foreign_key: true
      t.integer :value, null: false
      t.integer :vote_type, null: false

      t.timestamps
    end
  end
end
