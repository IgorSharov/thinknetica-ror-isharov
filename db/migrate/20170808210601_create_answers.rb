# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.belongs_to :question, foreign_key: true, null: false

      t.text :body, null: false

      t.timestamps
    end
  end
end
