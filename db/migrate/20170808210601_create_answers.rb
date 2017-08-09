# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.belongs_to :question, index: true

      t.string :title
      t.text :body

      t.timestamps
    end

    add_foreign_key :answers, :question
  end
end
